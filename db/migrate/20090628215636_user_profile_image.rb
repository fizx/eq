class UserProfileImage < ActiveRecord::Migration
  def self.up
    add_column :users, :profile_image_id, :integer
    rename_column :uploads, :uploaded_by, :uploaded_by_id
  end

  def self.down
  end
end
