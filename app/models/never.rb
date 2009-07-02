class Never < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  
  def description
    (activity ? activity.name : "do anything") + " with " +
    (user ? user.login : "anyone")
  end
end
