class CategoryMap
  attr_reader :mapping
  
  def self.associations
    @associations ||= Interest.reflect_on_all_associations(:belongs_to).map do |ass|
      ass.name.to_s
    end - ["user"]
  end
  
  def initialize(user, pseudocount = 5)
    @mapping = {}
    @pseudocount = pseudocount 
    user.interests.find(:all, :include => self.class.associations).each do |interest|
      self.class.associations.each do |category_type|
        category = interest.send(category_type)
        score category, interest.score
        if category.parent
          kids = category.parent.children
          s = interest.score.to_f / kids.length
          kids.each do |c|
            score c, s
          end
        end
        if category.children?
          kids = category.children
          s = interest.score.to_f / kids.length
          kids.each do |c|
            score c, s
          end          
        end
      end
    end
  end
  
  def get(name)
    klass_name = name.classify
    klass = Kernel.const_get(klass_name)
    count = klass.count
    
  end
  
  def score(category, score)
    category_type = category.class.to_s
    @mapping[category_type] ||= {}
    @mapping[category_type][category.id] ||= @pseudocount
    @mapping[category_type][category.id] += score
  end
end