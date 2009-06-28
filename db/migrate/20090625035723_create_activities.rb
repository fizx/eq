class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :type
      t.string :name
      t.integer :parent_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
