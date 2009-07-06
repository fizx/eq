class Bigints < ActiveRecord::Migration
  def self.up
    change_column :users, :fb_uid, :integer, :limit => 8
    change_column :events, :fb_eid, :integer, :limit => 8
  end

  def self.down
  end
end
