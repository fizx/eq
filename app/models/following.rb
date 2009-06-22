class Following < ActiveRecord::Base
  belongs_to :follower, :class_name => "User", :foreign_key => "follower_id"
  belongs_to :followee, :class_name => "User", :foreign_key => "followee_id"

  validates_presence_of :follower_id, :followee_id
  
  before_create :check_bidi
  after_create :update_bidi
  
  def check_bidi
    @other = Following.find_by_follower_id_and_followee_id(followee_id, follower_id)
    self.bidi = !!@other
    return true
  end
  
  def update_bidi
    if @other
      @other.update_attribute :bidi, true
      @other = nil
    end
    return true
  end
end
