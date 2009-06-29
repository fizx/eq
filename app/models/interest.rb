class Interest < ActiveRecord::Base
  belongs_to :user
  belongs_to :familiarity
  belongs_to :group_size
  belongs_to :proximity
  belongs_to :time_span
  belongs_to :activity
  
  has_many :intervals, :as => :intervalable
  
  include ActionController::UrlWriter
  
  after_save :create_intervals_from_time_span
  
  named_scope :of_friends_of, lambda{|user|
    {
      :joins => "INNER JOIN users AS friends ON interests.user_id=friends.id
                 INNER JOIN followings ON friends.id=followings.followee_id
                 INNER JOIN users AS current_users ON current_users.id=followings.follower_id",
      :conditions => "current_users.id=#{user.id}"
    }
  }
  
  named_scope :interval_overlapping_with, lambda{|interval|
    case interval
    when Interval
      {
        :joins => "INNER JOIN intervals ON intervals.intervalable_type='Interest' 
                                       AND intervals.intervalable_id=interests.id 
                                       AND intervals.start < '#{interval.finish.to_s(:db)}' 
                                       AND intervals.finish > '#{interval.start.to_s(:db)}'",
        :group => Interest.columns.map {|c| "interests.#{c.name}"}.join(", ")
      }
    when Interest: raise "wtf"
    when NilClass: {}
    end
  }
  
  
  
  # Defined as interests that share:
  # - user_id in this.user_id.followers.ids
  # - time_span overlap
  # - location overlap
  # - activity in this interests self/parent set
  def friendly_interests
    sql = <<-SQL
    
    SQL
    # find_by_sql(sql)
  end
  
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
