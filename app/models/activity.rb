class Activity < ActiveRecord::Base
  belongs_to :parent, :class_name => "Activity"
  has_many :children, :foreign_key => "parent_id", :class_name => "Activity"
  
  def self.all_roots
    find_all_by_parent_id(nil)
  end
  
  def self.build(data)
    delete_all
    _build(data, nil)
  end
  
private
  def self._build(data, parent_id)
    [data].flatten.each do |entry|
      case entry
      when String:
        Activity.create :parent_id => parent_id, :name => entry
      when Hash:
        entry.each do |k, v|
          a = Activity.create :parent_id => parent_id, :name => k
          _build(v, a.id)
        end
      end
    end
  end
end
