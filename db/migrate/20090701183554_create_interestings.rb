class CreateInterestings < ActiveRecord::Migration
  def self.up
    create_table :interestings do |t|
      t.integer :interest_id
      t.integer :user_id
      t.timestamps
    end
    
    add_column :interests, :interestings_count, :integer, :default => 0
  end

  def self.down
    remove_column :interests, :interestings_count
    drop_table :interestings
  end
end
