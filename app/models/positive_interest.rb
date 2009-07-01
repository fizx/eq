class PositiveInterest < Interest
  validates_presence_of :familiarity
  validates_presence_of :group_size
  validates_presence_of :proximity
  validates_presence_of :time_span

  def score
    1
  end
end