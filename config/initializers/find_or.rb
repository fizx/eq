class ActiveRecord::Base
  module ClassMethods
    def find_or_initialize(hash)
      find(:first, :conditions => hash) || new(hash)
    end
    
    def find_or_create(hash)
      m = find_or_initialize(hash)
      m.save if m.new_record?
      m
    end

    def find_or_create!(hash)
      m = find_or_initialize(hash)
      m.save! if m.new_record?
      m
    end
    
  end
  
  extend ClassMethods
end