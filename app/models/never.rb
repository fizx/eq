class Never < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  belongs_to :with_user, :class_name => "User"
  
  def description
    (activity ? activity.name : "do anything") + " with " +
    (with_user ? with_user.login : "anyone")
  end
end
