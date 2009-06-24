class IntervalPolymorphic < ActiveRecord::Migration
  def self.up
    add_column :intervals, :intervalable_type, :string
    add_column :intervals, :intervalable_id, :integer
    Interval.all.each do |i|
      i.intervalable_id = i.user_id
      i.intervalable_type = "User"
      i.save
    end
    remove_column :intervals, :user_id
    add_index :intervals, :intervalable_type
    add_index :intervals, :intervalable_id
  end

  def self.down
  end
end
