class Interest < ActiveRecord::Base
  belongs_to :user
  belongs_to :familiarity
  belongs_to :group_size
  belongs_to :proximity
  belongs_to :time_span
  belongs_to :activity
  
  include ActionController::UrlWriter
  
  def self.random
    i = Interest.new
    i.familiarity = Familiarity.all.rand
    i.activity = Activity.all.rand
    i.proximity = Proximity.all.rand
    i.group_size = GroupSize.all.rand
    i.time_span = TimeSpan.all.rand
    i
  end
  
  def negative?
    kind_of? NegativeInterest
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
