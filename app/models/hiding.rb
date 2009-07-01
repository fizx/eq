class Hiding < ActiveRecord::Base
  belongs_to :interest
  belongs_to :user
  validates_uniqueness_of :interest_id, :scope => :user_id
end
