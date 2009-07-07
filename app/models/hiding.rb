class Hiding < ActiveRecord::Base
  belongs_to :hidable, :polymorphic => true
  belongs_to :user
  validates_uniqueness_of :interest_id, :scope => :user_id
end
