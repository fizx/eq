require "active_support"
require "set"
class RangeSet < Set
  include Enumerable
  attr_reader :entries
  
  def initialize(ranges)
    @entries = ranges.map(&:to_a).flatten.uniq.sort
    super @entries
  end
  
  def each(*a, &b)
    @entries.each(*a, &b)
  end
  
end