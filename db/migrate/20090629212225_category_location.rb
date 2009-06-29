class CategoryLocation < ActiveRecord::Migration
  def self.up
    add_column :categories, :location_id, :integer
    add_column :categories, :radius, :float
  end

  def self.down
    remove_column :categories, :location_id
    remove_column :categories, :radius
  end
end
