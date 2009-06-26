class InterestTypes < ActiveRecord::Migration
  def self.up
    add_column :interests, :type, :string
  end

  def self.down
  end
end
