class PrivateCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :private, :boolean
  end

  def self.down
    remove_column :categories, :private
  end
end
