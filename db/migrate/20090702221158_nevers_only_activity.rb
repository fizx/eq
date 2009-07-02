class NeversOnlyActivity < ActiveRecord::Migration
  def self.up
    remove_column :nevers, :with_user_id
  end

  def self.down
  end
end
