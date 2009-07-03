class FollowingResponse < ActiveRecord::Migration
  def self.up
    add_column :followings, :responded, :boolean, :default => false
    add_index :followings, :responded
  end

  def self.down
  end
end
