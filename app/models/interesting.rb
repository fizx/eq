class Interesting < ActiveRecord::Base
  belongs_to :interest, :counter_cache => true
  belongs_to :user
  validates_uniqueness_of :interest_id, :scope => :user_id
end
