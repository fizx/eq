class GroupSize < Category
  ANOTHER_PERSON = GroupSize.find_or_create :name => "another person", :min => 2, :max => 2
  A_COUPLE_PEOPLE = GroupSize.find_or_create :name => "a couple people", :min => 2, :max => 4
  SEVERAL_PEOPLE = GroupSize.find_or_create :name => "several people", :min => 5, :max => 8
  A_LARGER_GROUP = GroupSize.find_or_create :name => "a larger group", :min => 8, :max => 20
end