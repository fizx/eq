class FacebookUser < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_data, :text
  end

  def self.down
    remove_column :users, :facebook_data
  end
end
