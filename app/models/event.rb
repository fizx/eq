class Event < ActiveRecord::Base
  attr_accessor :category, :start, :finish, :venue, :location, :invited
end
