class ValidLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :geocodable, :boolean, :default => false
    Location.update_all "geocodable=true"
  end

  def self.down
  end
end
