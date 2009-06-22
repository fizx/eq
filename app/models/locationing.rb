class Locationing < ActiveRecord::Base
  belongs_to :user
  belongs_to :interval
  belongs_to :location
  
  validates_presence_of :user
  validates_presence_of :location
  # interval optional
end
