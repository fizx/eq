class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  def self.confirm_emails(event, emails)
    emails.map do |email|
      user = User.from_email(email)
      Rsvp.create! :type => "ConfirmedRsvp", :user_id => user.id, :event_id => event.id
    end
  end
end
