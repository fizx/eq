class Locationing < ActiveRecord::Base
  belongs_to :location
  belongs_to :locatable, :polymorphic => true
  
  validates_presence_of :locatable_id
end
