class CreateIntervals < ActiveRecord::Migration
  def self.up
    create_table :intervals do |t|
      t.string :type
      t.datetime :start
      t.datetime :finish
      t.integer  :user_id
      t.timestamps
    end
    add_index :intervals, :type
    add_index :intervals, :user_id
  end

  def self.down
    remove_index :intervals, :type
    remove_index :intervals, :user_id
    drop_table :intervals
  end
end
