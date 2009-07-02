class Interval < ActiveRecord::Base
  validates_presence_of :start
  validates_presence_of :finish
  belongs_to :intervalable, :polymorphic => true
    
  validates_each(:start) do |r, a, v|
    if r.start && r.finish && r.start > r.finish
      r.errors.add(a, "must be before the finish")
    end
  end
  
  named_scope :inside_range, lambda { |range|
    {
      :conditions => ["start > ? AND finish < ?", range.first, range.last]
    }
  }

  named_scope :overlapping_range, lambda {|range| 
    {
      :conditions => ["finish > ? AND start < ?", range.first, range.last]
    }
  }
  
  def self.from(start, finish)
    new(:start => start, :finish => finish)
  end
  
  def to_range
    start..finish
  end
  
  def to_date_range
    (start.to_date)..(finish.to_date)
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
