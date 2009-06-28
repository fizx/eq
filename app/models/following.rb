class Following < ActiveRecord::Base
  belongs_to :follower, :class_name => "User", :foreign_key => "follower_id"
  belongs_to :followee, :class_name => "User", :foreign_key => "followee_id"

  validates_presence_of :follower_id, :followee_id
  
  before_create :check_bidi
  after_create :update_bidi
  
  before_destroy :check_bidi
  after_destroy :update_bidi
  
  def self.create_friendship(a, b)
    f = Following.find_or_initialize_by_follower_id_and_followee_id(a.id, b.id)
    f.bidi = true
    f.save!
    f = Following.find_or_initialize_by_follower_id_and_followee_id(b.id, a.id)
    f.bidi = true
    f.save!
  end
  
  def self.create_follows(a, b)
    f = Following.find_or_initialize_by_follower_id_and_followee_id(a.id, b.id)
    f.bidi = false
    f.save!
    f = Following.find_by_follower_id_and_followee_id(b.id, a.id)
    f.try(:destroy)
  end
  
  def check_bidi
    @other = Following.find_by_follower_id_and_followee_id(followee_id, follower_id)
    self.bidi = !!@other
    return true
  end
  
  def update_bidi
    if @other
      @other.update_attribute :bidi, !destroyed?
      @other = nil
    end
    return true
  end
  
  alias_method :destroyed?, :frozen?
end
