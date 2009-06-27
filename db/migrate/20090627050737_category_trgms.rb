class CategoryTrgms < ActiveRecord::Migration
  def self.up
    add_trgm_index :categories, :name
  end

  def self.down
  end
end
