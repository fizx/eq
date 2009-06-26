class CreateInterests < ActiveRecord::Migration
  def self.up
    create_table :interests do |t|
      t.integer :user_id
      t.integer :activity_id
      t.integer :time_span_id
      t.integer :proximity_id
      t.integer :group_size_id
      t.integer :familiarity_id

      t.timestamps
    end
  end

  def self.down
    drop_table :interests
  end
end
