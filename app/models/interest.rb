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
    i.time_span_id = TimeSpan.all.rand.id
    i.activity_id = PositiveInterest.random.try(:activity_id) || Activity.all.rand.id
    i
  end
  
  def negative?
    score < 0
  end
  
  def score
    0
  end
  
  def url_hash
    interest = {
      :type => self.class.to_s,
      :familiarity_id => familiarity_id,
      :group_size_id => group_size_id,
      :proximity_id => proximity_id,
      :time_span_id => time_span_id,
      :activity_id => activity_id
    }.hash_compact
    
    {
      :controller => "interests",
      :action => (new_record? ? "new" : "edit"),
      :interest => interest
    }
  end
  
  def description_segments
    [activity.name, time_span.name]#, proximity.name, "with #{group_size.name}", "that #{familiarity.name}"]
  end
  
  def description
    description_segments.join(" ")
  end
end
