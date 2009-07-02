class CreateNevers < ActiveRecord::Migration
  def self.up
    create_table :nevers do |t|
      t.integer :user_id
      t.integer :with_user_id
      t.integer :activity_id

      t.timestamps
    end
    add_index :nevers, :user_id
    add_index :nevers, :with_user_id
    add_index :nevers, :activity_id
    
    remove_column :interests, :type
  end

  def self.down
    drop_table :nevers
  end
end
