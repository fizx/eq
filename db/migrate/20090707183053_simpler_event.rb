class SimplerEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :start, :datetime
    add_column :events, :finish, :datetime
    add_index :events, :start
    add_index :events, :finish
    Event.each do |e|
      e.start = e.interval.try :start
      e.finish = e.interval.try :finish
      e.save
    end
  end

  def self.down
  end
end
