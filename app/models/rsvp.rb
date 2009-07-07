class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  def self.confirm_emails(event, emails)
    emails.map do |email|
      user = User.from_email(email)
      Rsvp.create! :type => "ConfirmedRsvp", :user_id => user.id, :event_id => event.id
    end
  end
  
  named_scope :unresponded, {
    :conditions => "rsvps.type IS NULL OR rsvps.type = 'Rsvp'"
  }
  
  named_scope :confirmed, {
    :conditions => "rsvps.type = 'ConfirmedRsvp'"
  }
  
  named_scope :declined, {
    :conditions => "rsvps.type = 'DeclinedRsvp'"
  }
  
  named_scope :maybe, {
    :conditions => "rsvps.type = 'MaybeRsvp'"
  }
  
  named_scope :actioned, {
    :conditions => "rsvps.type IS NOT NULL AND rsvps.type <> 'Rsvp'"
  }
  
  named_scope :future, {
    :joins => "INNER JOIN events on events.id=rsvps.event_id",
    :conditions => "events.start > NOW()"
  }
end
