class Locatable < ActiveRecord::Migration
  def self.up
    remove_column :locationings, :user_id
    remove_column :locationings, :interval_id
    add_column :locationings, :locatable_id, :integer
    add_column :locationings, :locatable_type, :string
    add_index :locationings, :locatable_id
    add_index :locationings, :locatable_type
  end

  def self.down
    add_column :locationings, :user_id, :integer
    add_column :locationings, :interval_id, :integer
    remove_column :locationings, :locatable_id
    remove_column :locationings, :locatable_type
  end
end
