class CreateLocationings < ActiveRecord::Migration
  def self.up
    create_table :locationings do |t|
      t.integer :user_id
      t.integer :location_id
      t.integer :interval_id
      t.timestamps
    end
    add_index :locationings, :user_id
    add_index :locationings, :location_id
    add_index :locationings, :interval_id
  end

  def self.down
    drop_table :locationings
    remove_index :locationings, :user_id
    remove_index :locationings, :location_id
    remove_index :locationings, :interval_id
  end
end
