class TimeSpan < Category
  has_many :intervals, :as => :intervalable
end