class Interest < ActiveRecord::Base
  belongs_to :user
  belongs_to :familiarity
  belongs_to :group_size
  belongs_to :proximity
  belongs_to :time_span
  belongs_to :activity
  
  validates_presence_of :user
  validates_presence_of :activity
  
  has_many :intervals, :as => :intervalable
  
  include ActionController::UrlWriter
  
  after_save :create_intervals_from_time_span
  
  def create_intervals_from_time_span
    Interval.delete_all "intervalable_id=#{self.id} AND intervalable_type='Interest'"
    if time_span && intervals = time_span.intervals
      intervals.each do |interval|
        interval.intervalable = self
        interval.save!
      end
    end
  end
  
  named_scope :of_friends_of, lambda{|user|
    {
      :joins => "INNER JOIN users AS friends ON interests.user_id=friends.id
                 INNER JOIN followings ON friends.id=followings.followee_id
                 INNER JOIN users AS current_users ON current_users.id=followings.follower_id",
      :conditions => "current_users.id=#{user.id}"
    }
  }
  
  named_scope :activity_overlapping_with, lambda{|activity|
    activity = activity.activity      if activity.is_a?(Interest)
    return                            unless activity.is_a?(Activity)
    
    with = <<-SQL
      RECURSIVE 
      children(id) AS (
          VALUES(#{activity.id})
        UNION
          SELECT categories.id FROM categories, children 
                               WHERE categories.parent_id = children.id 
                               AND categories.id IS NOT NULL
      ),
      ancestors(id) AS (
          VALUES(#{activity.id})
        UNION
          SELECT categories.parent_id FROM categories, ancestors 
                             WHERE categories.id = ancestors.id 
                             AND categories.parent_id IS NOT NULL
      )
    SQL
    {
      :with => with,
      :conditions => "interests.activity_id IN (select id from children UNION select id from ancestors)"
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
    when Interest: 
      {
        :from => "intervals AS other_intervals, intervals, interests",
        :conditions => "
          intervals.intervalable_type='Interest' 
          AND intervals.intervalable_id=interests.id
          AND other_intervals.intervalable_type='Interest'
          AND other_intervals.intervalable_id = #{interval.id}
          AND intervals.start < other_intervals.finish 
          AND intervals.finish > other_intervals.start
        ",
        :group => Interest.columns.map {|c| "interests.#{c.name}"}.join(", ")
      }
    when NilClass: {}
    end
  }
  
  named_scope :proximity_overlapping_with, lambda{|location|
    
  }

  # 
  # Interest.of_friends_of(user).
  #          interval_overlapping_with(self).
  #          activity_overlapping_with(activity).
  #          proximity_overlapping_with(proximity)  
  named_scope :friendly_interests, lambda {|interest, user|
    activity = interest.activity
    proximity = interest.proximity
    
    with = <<-SQL
      RECURSIVE 
      children(id) AS (
          VALUES(#{activity.id})
        UNION
          SELECT categories.id FROM categories, children 
                               WHERE categories.parent_id = children.id 
                               AND categories.id IS NOT NULL
      ),
      ancestors(id) AS (
          VALUES(#{activity.id})
        UNION
          SELECT categories.parent_id FROM categories, ancestors 
                             WHERE categories.id = ancestors.id 
                             AND categories.parent_id IS NOT NULL
      )
    SQL
     
    {
      :with => with,
      :select => "interests.*",
      :from => "interests, 
                users AS friends, 
                followings, 
                users AS current_users,
                intervals AS other_intervals, 
                intervals,
                categories AS proximities,
                categories AS other_proximities,
                locations,
                locations AS other_locations,
                interests AS other_interests
                ",
      :conditions => "interests.activity_id IN (select id from children UNION select id from ancestors)
                  AND interests.user_id=friends.id
                  AND friends.id=followings.followee_id
                  AND current_users.id=followings.follower_id
                  AND current_users.id=#{user.id}
                  AND intervals.intervalable_type='Interest' 
                  AND intervals.intervalable_id=interests.id
                  AND other_intervals.intervalable_type='Interest'
                  AND other_intervals.intervalable_id = #{interest.id}
                  AND other_interests.id = #{interest.id}
                  AND intervals.start < other_intervals.finish 
                  AND intervals.finish > other_intervals.start
                  AND intervals.finish > NOW()
                  AND other_intervals.finish > NOW()
                  AND interests.proximity_id = proximities.id
                  AND other_interests.proximity_id = other_proximities.id
                  AND proximities.location_id = locations.id
                  AND other_proximities.location_id = other_locations.id
                  AND point(locations.lng, locations.lat) 
                      <@> 
                      point(other_locations.lng, other_locations.lat) 
                          <= proximities.radius + other_proximities.radius
      "            ,
                  :group => Interest.columns.map {|c| "interests.#{c.name}"}.join(", ")
    }
  }
  
  def friendly_interests(user = self.user)
    Interest.friendly_interests(self, user)
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
