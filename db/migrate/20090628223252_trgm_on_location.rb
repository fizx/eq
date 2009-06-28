class TrgmOnLocation < ActiveRecord::Migration
  def self.up
    add_trgm_index :locations, :name
  end

  def self.down
  end
end
