class FbEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :fb_eid, :integer
    add_index :events, :fb_eid
  end

  def self.down
  end
end
