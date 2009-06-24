require 'digest/sha1'
# require "geokit"
class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  has_many :web_calendars

  has_many :friendings_as_followee, :foreign_key => "followee_id", :class_name => "Following", 
                                    :conditions => {:bidi => true}
  has_many :followings_as_followee, :foreign_key => "followee_id", :class_name => "Following"
  has_many :followings_as_follower, :foreign_key => "follower_id", :class_name => "Following"
  has_many :followers, :through => :followings_as_followee
  has_many :followees, :through => :followings_as_follower
  has_many :friends, :through => :friendings_as_followee, :source => :follower
  
  has_many :locationings, :as => :locatable
  has_many :default_locationings, :as => :locatable
  has_many :locations, :through => :locationings
  has_one :default_location, :through => :default_locationings, :source => :location
  
  has_many :busy_intervals, :as => :intervalable
  has_many :trips, :as => :intervalable

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :location_string
  
  def location_string
    @location_string ||= location.try(:name)
  end
  
  def location_string=(string)
    @location_string = string
    @location_string_dirty = true
  end
  
  before_save :update_location_string
  
  def update_location_string
    self.default_location = Location.from(@location_string) if @location_string_dirty
    @location_string_dirty = false
    true
  end
  
  def default_location=(loc)
    self.default_locationings.clear
    ing = DefaultLocationing.new
    ing.location = loc
    ing.locatable = self
    ing.save!
    ing
  end
  
  def events
    busy_intervals + trips
  end
  
  def location
    default_location
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
  
  def scheduled_events
    []
  end
  
  def desired_events
    []
  end

  protected
    


end
