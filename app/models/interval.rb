class Interval < ActiveRecord::Base
  validates_presence_of :start
  validates_presence_of :finish
  
  validates_each(:start) do |r, a, v|
    if r.start && r.finish && r.start > r.finish
      r.errors.add(a, "must be before the finish")
    end
  end
end
