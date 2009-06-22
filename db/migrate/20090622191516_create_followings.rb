class CreateFollowings < ActiveRecord::Migration
  def self.up
    create_table :followings do |t|
      t.integer :follower_id
      t.integer :followee_id
      t.boolean :bidi
      t.timestamps
    end
    add_index :followings, :follower_id
    add_index :followings, :followee_id
  end

  def self.down
    remove_index :followings, :follower_id
    remove_index :followings, :followee_id
    drop_table :followings
  end
end
