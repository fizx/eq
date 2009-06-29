class CategoryMinMax < ActiveRecord::Migration
  def self.up
    add_column :categories, :min, :integer
    add_column :categories, :max, :integer
  end

  def self.down
  end
end
