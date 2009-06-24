class ActiveRecord::Base
  def self.validates_email(field)
    validates_format_of field,    
                        :with => Authentication.email_regex, 
                        :message => Authentication.bad_email_message
  end
end


