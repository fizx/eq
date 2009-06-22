class Following < ActiveRecord::Base
  belongs_to :follower, :class_name => "User", :foreign_key => "follower_id"
  belongs_to :followee, :class_name => "User", :foreign_key => "followee_id"
  belongs_to :friend, :foreign_key => "follower_id", :class_name => "User", 
                      :conditions => {:bidi => true}

  validates_presence_of :follower_id, :followee_id
end
