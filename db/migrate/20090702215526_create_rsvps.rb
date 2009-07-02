class CreateRsvps < ActiveRecord::Migration
  def self.up
    create_table :rsvps do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :type

      t.timestamps
    end
    
    add_index :rsvps, :user_id
    add_index :rsvps, :event_id
    add_index :rsvps, :type
  end

  def self.down
    drop_table :rsvps
  end
end
