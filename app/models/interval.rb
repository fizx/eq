class Interval < ActiveRecord::Base
  validates_presence_of :start
  validates_presence_of :finish
  belongs_to :intervalable, :polymorphic => true
    
  validates_each(:start) do |r, a, v|
    if r.start && r.finish && r.start > r.finish
      r.errors.add(a, "must be before the finish")
    end
  end
  
  def self.from(start, finish)
    Interval.new(:start => start, :finish => finish)
  end
  
  def busy
    nil
  end
  
  def startms
    (start.to_f * 1000).to_i
  end
  
  def finishms
    (finish.to_f * 1000).to_i
  end

  def location_string=(s)
    @s = s
  end
  
  def location_string
    @s
  end
  
end
