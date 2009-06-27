class Interest < ActiveRecord::Base
  belongs_to :user
  belongs_to :familiarity
  belongs_to :group_size
  belongs_to :proximity
  belongs_to :time_span
  belongs_to :activity
  
  include ActionController::UrlWriter
  
  def self.random_interest
    i = Interest.new
    i.familiarity_id = PositiveInterest.random.familiarity_id
    i.activity_id = PositiveInterest.random.activity_id
    i.proximity_id = PositiveInterest.random.proximity_id
    i.group_size_id = PositiveInterest.random.group_size_id
    i.time_span_id = PositiveInterest.random.time_span_id
    i
  end
  
  def negative?
    score < 0
  end
  
  def score
    0
  end
  
  def url_hash
    {
      :controller => "interests",
      :action => (new_record? ? "new" : "edit"),
      :interest => {
        :type => self.class.to_s,
        :familiarity_id => familiarity_id,
        :group_size_id => group_size_id,
        :proximity_id => proximity_id,
        :time_span_id => time_span_id,
        :activity_id => activity_id
      }
    }
  end
  
  def description_segments
    [activity.name, time_span.name, proximity.name, "with #{group_size.name}", "that #{familiarity.name}"]
  end
  
  def description
    description_segments.join(" ")
  end
end
