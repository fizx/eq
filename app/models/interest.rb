
class Interest < ActiveRecord::Base
  belongs_to :user
  belongs_to :familiarity
  belongs_to :group_size
  belongs_to :proximity
  belongs_to :time_span
  belongs_to :activity
  validates_presence_of :familiarity
  validates_presence_of :group_size
  validates_presence_of :proximity
  validates_presence_of :time_span
  
  validates_presence_of :user
  validates_presence_of :activity
  
  has_many :intervals, :as => :intervalable
  
  include ActionController::UrlWriter
  
  after_save :create_intervals_from_time_span
  
  def self.activity_with_sql(aid)
    with = <<-SQL
      RECURSIVE 
      children(id) AS (
          VALUES(#{aid})
        UNION
          SELECT categories.id FROM categories, children 
                               WHERE categories.parent_id = children.id 
                               AND categories.id IS NOT NULL
      ),
      ancestors(id) AS (
          VALUES(#{aid})
        UNION
          SELECT categories.parent_id FROM categories, ancestors 
                             WHERE categories.id = ancestors.id 
                             AND categories.parent_id IS NOT NULL
      )
    SQL
  end
  
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
      :select => "interests.*",
      :from => "users AS friends, followings, users AS current_users, interests",
      :conditions => "current_users.id=#{user.id}
                  AND interests.user_id=friends.id
                  AND friends.id=followings.followee_id
                  AND current_users.id=followings.follower_id"
    }
  }
  
  named_scope :not_hidden_to, lambda{|user|
    {
      # :conditions => "interests.id NOT IN (SELECT interest_id FROM hidings WHERE user_id=#{user.id})"
    }
  }
  
  def self.visible_to(user)
    not_hidden_to(user).excluding_nevers_for(user)
  end
  
  named_scope :activity_overlapping_with, lambda{|activity|
    aid = activity.is_a?(Activity) ? activity.id : activity.activity_id
    {
      :with => activity_with_sql(aid),
      :conditions => "interests.activity_id IN (select id from children UNION select id from ancestors)"
    }
  }
  
  named_scope :interval_overlapping_with, lambda{ |object|
    case object
    when Interval:
      {
        :select => "interests.*",
        :from => "intervals, interests",
        :conditions => "
          intervals.intervalable_type='Interest' 
          AND intervals.intervalable_id=interests.id
          AND intervals.start < '#{object.finish.to_s(:db)}'
          AND intervals.finish > '#{object.start.to_s(:db)}'
        ",
        :group => Interest.columns.map {|c| "interests.#{c.name}"}.join(", ")
      }
    when Interest:
      {
        :select => "interests.*",
        :from => "intervals, intervals AS other_intervals, interests",
        :conditions => "
          intervals.intervalable_type='Interest' 
          AND intervals.intervalable_id=interests.id
          AND other_intervals.intervalable_type='Interest'
          AND other_intervals.intervalable_id = #{object.id}
          AND intervals.start < other_intervals.finish 
          AND intervals.finish > other_intervals.start
        ",
        :group => Interest.columns.map {|c| "interests.#{c.name}"}.join(", ")
      }
    end
  }
  
  named_scope :in_the_future, {
    :select => "interests.*",
    :from => "intervals, interests",
    :conditions => "intervals.intervalable_type='Interest' 
                AND intervals.intervalable_id=interests.id
                AND intervals.finish > NOW()"
  }
  
  named_scope :with_critical_mass, lambda {|multiplier|
    multiplier = " * #{multiplier}" if multiplier
    {
      :select => "interests.*",
      :from => "categories AS group_sizes, interests",
      :conditions => "group_sizes.id = interests.group_size_id 
                  AND interests.interestings_count >= group_sizes.min #{multiplier}"
    }
  }
  
  named_scope :excluding_nevers_for, lambda {|user|
    {
      :conditions => 
        "interests.activity_id NOT IN (SELECT activity_id FROM nevers WHERE user_id=#{user.id})"
    }
  }
  
  named_scope :proximity_overlapping_with, lambda{ |object|
    case object
    when Interest:
      {
        :select => "interests.*",
        :from => "interests AS other_interests,
                    categories AS proximities,
                    categories AS other_proximities,
                    locations,
                    locations AS other_locations,
                    interests",
        :conditions => "other_interests.id = #{object.id}
                        AND interests.proximity_id = proximities.id
                        AND other_interests.proximity_id = other_proximities.id
                        AND proximities.location_id = locations.id
                        AND other_proximities.location_id = other_locations.id
                        AND point(locations.lng, locations.lat) 
                          <@> 
                          point(other_locations.lng, other_locations.lat) 
                              <= proximities.radius + other_proximities.radius
                        ",
        :group => Interest.columns.map {|c| "interests.#{c.name}"}.join(", ")
      }
    when Proximity:
      {
        :select => "interests.*",
        :from => "categories AS proximities,
                  categories AS other_proximities,
                  locations,
                  locations AS other_locations,
                  interests",
        :conditions => "    other_proximities.id = #{object.id}
                        AND interests.proximity_id = proximities.id
                        AND proximities.location_id = locations.id
                        AND other_proximities.location_id = other_locations.id
                        AND point(locations.lng, locations.lat) 
                          <@> 
                          point(other_locations.lng, other_locations.lat) 
                              <= proximities.radius + other_proximities.radius
                        ",
        :group => Interest.columns.map {|c| "interests.#{c.name}"}.join(", ")
      }
    end
  }
  
  def self.friendly_interests(interest, user)
    Interest.of_friends_of(user).
              in_the_future.
              visible_to(user).
              interval_overlapping_with(interest).
              activity_overlapping_with(interest).
              proximity_overlapping_with(interest)
  end
  
  
  def friend_availability_for(user, count = 10)
    days = RangeSet.new(intervals.map(&:to_date_range)).entries.first(count)
    days.map do |day|
      user_count = User.friends_of(user).available_at(day).interested_in_attending(self).count("users.id", :distinct => true)
      Availability.new(self, day, user_count)
    end
  end

  def friendly_interests(user = self.user)
    Interest.friendly_interests(self, user)
  end
  
  def has_critical_mass?(multiplier = 1.0)    
    group_size && interestings >= group_size.min * multiplier
  end
  
  def description_segments
    [activity.name, time_span.name] #, proximity.name, "with #{group_size.name}", "that #{familiarity.name}"]
  end
  
  def description
    description_segments.join(" ")
  end
end
