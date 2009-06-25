class Activity < Category
  belongs_to :parent, :class_name => "Activity"
  has_many :children, :foreign_key => "parent_id", :class_name => "Activity"  
end
