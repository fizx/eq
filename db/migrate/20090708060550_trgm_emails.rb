class TrgmEmails < ActiveRecord::Migration
  def self.up
    add_trgm_index :users, :email
  end

  def self.down
  end
end
