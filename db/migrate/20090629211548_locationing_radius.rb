class LocationingRadius < ActiveRecord::Migration
  def self.up
    add_column :locationings, :radius, :integer
  end

  def self.down
  end
end
