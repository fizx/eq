class CreateEventlets < ActiveRecord::Migration
  def self.up
    create_table :eventlets do |t|
      t.string :matcher
      t.string :name
      t.string :category
      t.string :description
      t.string :venue
      t.string :location
      t.string :start
      t.string :finish

      t.timestamps
    end
  end

  def self.down
    drop_table :eventlets
  end
end
