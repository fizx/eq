class EmailAddress < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :address, :scope => [:user_id, :type]
  validates_presence_of :user_id
  validates_presence_of :address
  validates_email       :address
end
