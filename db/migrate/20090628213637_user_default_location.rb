class UserDefaultLocation < ActiveRecord::Migration
  def self.up
    add_column :users, :default_location_id, :integer
  end

  def self.down
  end
end
