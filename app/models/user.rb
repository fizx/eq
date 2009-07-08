require 'digest/sha1'
# require "geokit"
class User < ActiveRecord::Base
  trgm_index :email
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  serialize :facebook_data

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_email           :email

  # validates_presence_of     :time_zone
  # validates_presence_of     :default_location_id
  
  has_many :web_calendars
  has_many :interests
  has_many :interests
  has_many :nevers
  has_many :events, :foreign_key => "creator_id"
  
  has_many :rsvps 
  
  has_many :friendings_as_follower, :foreign_key => "follower_id", :class_name => "Following", 
                                    :conditions => {:bidi => true}
  has_many :followees, :through => :followings_as_follower
  has_many :followings_as_followee, :foreign_key => "followee_id", :class_name => "Following", 
                             :conditions => {:weak => false}
  has_many :followings_as_follower, :foreign_key => "follower_id", :class_name => "Following", 
                             :conditions => {:weak => false}
  has_many :weak_followings, :foreign_key => "follower_id", :class_name => "Following", 
                             :conditions => {:weak => true}
  has_many :followers, :through => :followings_as_followee
  has_many :followees, :through => :followings_as_follower
  has_many :weak_followees, :through => :weak_followings, :source => :followee
  has_many :friends, :through => :friendings_as_follower, :source => :followee
  
  has_many :found_email_addresses
  
  belongs_to :default_location, :class_name => "Location"
  belongs_to :profile_image, :class_name => "UploadedImage"
  
  has_many :busy_events
  has_many :trips
  
  has_many :uploaded_images, :foreign_key => :uploaded_by_id

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  # attr_accessible :login, :email, :name, :password, :password_confirmation, :location_string
  attr_protected :type
  
  named_scope :friends_of, lambda {|user|
    #TODo
  }
  
  named_scope :known_to, lambda {|user|
  }
  
  named_scope :available_at, lambda {|time|
    {
      :select => "DISTINCT users.*",
      :joins => "LEFT JOIN intervals AS busy_events ON 
                      busy_events.intervalable_type='User'
                  AND busy_events.intervalable_id=users.id
                  AND busy_events.start < '#{time.to_s(:db)}'
                  AND busy_events.finish > '#{time.to_s(:db)}'",
      :group => User.columns.map {|c| "users.#{c.name}"}.join(", "),
      :having => "max(busy_events.id) IS NULL"
    }
  }
  
  named_scope :interested_in_attending, lambda{|interest|
    {
      :with => Interest.activity_with_sql(interest.activity_id),
      :select => "users.*",
      :from => "interests, 
                intervals, 
                intervals AS this_intervals, 
                users",
      :joins => "LEFT JOIN interestings ON interestings.user_id=users.id",
      :conditions => "(interests.user_id = users.id OR interests.id=interestings.interest_id)
                  AND interests.activity_id IN (select id from children UNION select id from ancestors)
                  AND intervals.intervalable_id=interests.id
                  AND intervals.intervalable_type='Interest'
                  AND intervals.start < this_intervals.finish
                  AND intervals.finish > this_intervals.start
                  AND this_intervals.intervalable_id = #{interest.id} 
                  AND this_intervals.intervalable_type = 'Interest'
                  ",
      :group => User.columns.map {|c| "users.#{c.name}"}.join(", "),
    }
  }
  
  def location_string
    default_location.try(:name)
  end
  
  def location_string=(string)
    self.default_location = Location.from(string)
  end
  
  def profile_image_url
    profile_image.try(:public_filename)
  end
  
  def profile_image_thumb
    profile_image && profile_image.public_filename(:thumb)
  end
  
  def self.from_email(email)
    email && User.find_or_create_by_email(email)
  end
  
  def profile_image_file
    
  end
  
  def follows?(user)
    Following.count(:conditions => {:follower_id => id, :followee_id => user.id}) > 0
  end
  
  def profile_image_file=(f)
    img = UploadedImage.create!(:uploaded_data => f, :uploaded_by_id => self.id)
    self.profile_image = img
  end
  
  def short_name
    if name.present?
      arr = name.split(" ")
      arr.shift + arr.map{|n| " #{n[0..0].upcase}."}.join("")
    else
      email
    end
  end
  
  def hides_interest(interest)
    return true if hidden?(interest)
    Hiding.create!(:user_id => id, :hidable_id => interest.id, :hidable_type => interest.class.to_s)
  end
  
  def hidden?(interest)
    Hiding.count(:conditions => {:user_id => id, :hidable_id => interest.id, :hidable_type => interest.class.to_s}) > 0
  end
  
  def interesting?(interest)
    interest.user_id == id || 
    Interesting.count(:conditions => {:user_id => id, :interest_id => interest.id}) > 0
  end
  
  def is_interested_in(interest)
    return true if interesting?(interest)
    Interesting.create!(:user_id => id, :interest_id => interest.id)
  end
  
  def self.find_any_email(emails)
    find :all, :conditions => ["email IN(?)", emails] 
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_by_email(email.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def followees?
    followees.present?
  end
  
  def found_email_addresses?
    found_email_addresses.present?
  end
  
  def scheduled_events
    []
  end
  
  def event_status(event)
    Rsvp.find_by_event_id_and_user_id(event.id, self.id).status
  end
  
  def never(interest)
    Never.find_by_user_id_and_activity_id id, interest.activity_id
  end
  
  def desired_events
    []
  end
  
  def web_calendars?
    web_calendars.present?
  end
  
  def invitable_count
    weak_followees.length
  end
  
  def add_found_emails(emails)
    emails && emails.each do |e|
      user = User.find_or_initialize_by_email(e)
      user.save(false) if user.new_record?
      f = Following.find_or_initialize :follower_id => id, :followee_id => user.id
      f.weak = true if f.new_record?
      f.save!
    end
  end
  
  def has_permissions?
    facebook_data && facebook_data[:create_event] && facebook_data[:rsvp_event] && facebook_data[:offline_access]
  end
  
  def needs_permissions?
    uses_facebook? && !has_permissions?
  end
  
  def uses_facebook?
    !!fb_uid
  end
  
  def admin?
    is_a?(AdminUser)
  end

  protected
    


end
