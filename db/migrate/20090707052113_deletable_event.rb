class DeletableEvent < ActiveRecord::Migration
  def self.up
    rename_column :hidings, :interest_id, :hidable_id
    add_column :hidings, :hidable_type, :string
    add_index :hidings, :hidable_type
    Hiding.update_all "hidable_type='Interest'"
  end

  def self.down
  end
end
