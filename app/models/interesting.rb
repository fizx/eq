class Interesting < ActiveRecord::Base
  validates_uniqueness_of :interest_id, :scope => :user_id
end
