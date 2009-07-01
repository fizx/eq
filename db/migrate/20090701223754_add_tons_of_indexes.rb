class AddTonsOfIndexes < ActiveRecord::Migration
  def self.up
    add_index :categories, [:type, :id]
    add_index :categories, :id
    
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :user_id
    
    add_index :email_addresses, [:type, :id]
    add_index :email_addresses, :user_id 
    
    add_index :eventlets, :matcher
    
    add_index :events, :creator_id
    
    add_index :followings, [:follower_id, :followee_id, :bidi]
    
    add_index :hidings, :user_id
    add_index :hidings, :interest_id
    
    add_index :interestings, :user_id
    add_index :interestings, :interest_id
    
    add_index :interests, [:type, :id]
    add_index :interests, :user_id
    add_index :interests, :activity_id
    add_index :interests, :time_span_id
    add_index :interests, :proximity_id
    add_index :interests, :group_size_id
    add_index :interests, :familiarity_id
    
    add_index :intervals, :start
    add_index :intervals, :finish
    
    add_index :invitations, :user_id
  end

  def self.down
    remove_index :categories, [:type, :id]
    remove_index :categories, :id

    remove_index :comments, [:commentable_id, :commentable_type]
    remove_index :comments, :user_id

    remove_index :email_addresses, [:type, :id]
    remove_index :email_addresses, :user_id 

    remove_index :eventlets, :matcher

    remove_index :events, :creator_id

    remove_index :followings, [:follower_id, :followee_id, :bidi]

    remove_index :hidings, :user_id
    remove_index :hidings, :interest_id

    remove_index :interestings, :user_id
    remove_index :interestings, :interest_id

    remove_index :interests, [:type, :id]
    remove_index :interests, :user_id
    remove_index :interests, :activity_id
    remove_index :interests, :time_span_id
    remove_index :interests, :proximity_id
    remove_index :interests, :group_size_id
    remove_index :interests, :familiarity_id

    remove_index :intervals, :start
    remove_index :intervals, :finish

    remove_index :invitations, :user_id
  end
end
