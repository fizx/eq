class Never < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  validates_presence_of :user
  validates_presence_of :activity
  
  def description
    activity.try(:name)
  end
end
