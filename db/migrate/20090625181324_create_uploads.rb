class CreateUploads < ActiveRecord::Migration
  def self.up
    create_table :uploads do |t|
      t.integer :uploadable_id
      t.string :uploadable_type
      t.integer :uploaded_by
      t.string :content_type
      t.string :filename
      t.integer :size
      t.integer :width
      t.integer :height
      t.integer :parent_id
      t.string :thumbnail
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :uploads
  end
end
