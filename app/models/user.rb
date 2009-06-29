require 'digest/sha1'
# require "geokit"
class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_presence_of     :default_location_id
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_email           :email

  validates_presence_of     :time_zone
  
  has_many :web_calendars
  has_many :interests
  has_many :positive_interests
  has_many :negative_interests

  has_many :friendings_as_followee, :foreign_key => "followee_id", :class_name => "Following", 
                                    :conditions => {:bidi => true}
  has_many :followings_as_followee, :foreign_key => "followee_id", :class_name => "Following"
  has_many :followings_as_follower, :foreign_key => "follower_id", :class_name => "Following"
  has_many :followers, :through => :followings_as_followee
  has_many :followees, :through => :followings_as_follower
  has_many :friends, :through => :friendings_as_followee, :source => :follower
  
  has_many :found_email_addresses
  
  belongs_to :default_location, :class_name => "Location"
  belongs_to :profile_image, :class_name => "UploadedImage"
  
  has_many :intervals, :as => :intervalable
  has_many :busy_intervals, :as => :intervalable
  has_many :trips, :as => :intervalable
  
  has_many :uploaded_images, :foreign_key => :uploaded_by_id

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  # attr_accessible :login, :email, :name, :password, :password_confirmation, :location_string
  attr_protected :type
  
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
  
  def profile_image_file
    
  end
  
  def follows?(user)
    Following.count(:conditions => {:follower_id => id, :followee_id => user.id}) > 0
  end
  
  def profile_image_file=(f)
    img = UploadedImage.create!(:uploaded_data => f, :uploaded_by_id => self.id)
    self.profile_image = img
  end
  
  def to_param
    "#{id}-#{login}"
  end
  
  def events
    busy_intervals + trips
  end
  
  def new_interest
    activity_id, time_span_id = (
      Activity.interest_cache - 
        interests.find(:all, :select => "activity_id, time_span_id").map{|i| [i.activity_id, i.time_span_id] }
    ).rand
    
    return nil unless activity_id
    
    Interest.new(:activity_id => activity_id, :time_span_id => time_span_id)
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
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
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
  
  def desired_events
    []
  end
  
  def web_calendars?
    web_calendars.present?
  end
  
  def invitable_count
    found_email_addresses.length - followees.length
  end
  
  def add_found_emails(emails)
    emails.each do |e|
      FoundEmailAddress.find_or_create_by_user_id_and_address(self.id, e)
    end
  end
  
  def admin?
    is_a?(AdminUser)
  end

  protected
    


end
