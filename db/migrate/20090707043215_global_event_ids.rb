class GlobalEventIds < ActiveRecord::Migration
  def self.up
    add_column :events, :guid, :string
    Event.all.each{|e| e.update_attribute :guid, "#{e.fb_eid}@facebook.com"}
    remove_column :events, :fb_eid
    add_index :events, :guid
  end

  def self.down
  end
end
