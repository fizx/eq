class ActivitiesToCategories < ActiveRecord::Migration
  def self.up
    drop_table "categories" rescue nil
    rename_table "activities", "categories"
  end

  def self.down
  end
end
