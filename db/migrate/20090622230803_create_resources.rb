class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :type
      t.text :url
      t.text :data
      t.integer :user_id

      t.timestamps
    end
    add_index :resources, :type
    add_index :resources, :user_id
  end

  def self.down
    remove_index :resources, :type
    remove_index :resources, :user_id
    drop_table :resources
  end
end
