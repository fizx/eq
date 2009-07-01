class CreateHidings < ActiveRecord::Migration
  def self.up
    create_table :hidings do |t|
      t.integer :interest_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :hidings
  end
end
