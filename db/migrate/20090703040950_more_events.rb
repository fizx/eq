class MoreEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :location_id, :integer
    add_column :events, :activity_id, :integer
    add_column :events, :venue, :text
    
    add_column :events, :start, :datetime
    add_column :events, :finish, :datetime
    
    add_index :events, :location_id
    add_index :events, :activity_id
    
    add_index :events, :start
    add_index :events, :finish
    
  end

  def self.down
    remove_column :events, :location_id
    remove_column :events, :activity_id
    remove_column :events, :venue

    remove_column :events, :start
    remove_column :events, :finish    
  end
end
