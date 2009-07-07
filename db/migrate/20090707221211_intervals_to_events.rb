class IntervalsToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :type, :string
    add_index :events, :type
    remove_column :intervals, :type
  end

  def self.down
  end
end
