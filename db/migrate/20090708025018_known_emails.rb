class KnownEmails < ActiveRecord::Migration
  def self.up
    drop_table :email_addresses rescue nil
    add_column :followings, :weak, :boolean, :default => false
    add_index :followings, :weak
  end

  def self.down
  end
end
