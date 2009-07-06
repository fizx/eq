class FbUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_uid, :integer
    add_column :users, :email_hash, :string
    add_index :users, :fb_uid
    add_index :users, :email_hash
  end

  def self.down
  end
end
