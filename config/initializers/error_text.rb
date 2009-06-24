class ActiveRecord::Base
  def error_text
    errors.full_messages.join(", ")
  end
end