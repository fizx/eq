class Invitation < ActiveRecord::Base
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_presence_of :email
  validates_presence_of :message
  
  DEFAULT_MESSAGE = <<-STR
Hi,
I'd like to invite you to try eq, a social network that actually helps you be more social in the real world!  It gets more useful when you have more friends involved.

Signing up is really easy!
  STR
  
  def initialize
    super
    self[:message] ||= DEFAULT_MESSAGE.strip
  end
end
