class CategoryData < ActiveRecord::Migration
  def self.up
    add_column :categories, :data, :text
  end

  def self.down
    remove_column :categories, :data
  end
end
