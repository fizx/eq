class CreateDefaultLocationing < ActiveRecord::Migration
  def self.up
    add_column :locationings, :type, :string
    add_index :locationings, :type
  end

  def self.down
  end
end
