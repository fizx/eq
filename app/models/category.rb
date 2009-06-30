class Category < ActiveRecord::Base
  trgm_index :name
  
  belongs_to :parent, :class_name => "Category"
  has_many :children, :foreign_key => "parent_id", :class_name => "Category"  
  
  def self.all
    find_all_by_type(self.to_s)
  end
  
  def self.build_all_from_yaml
    subclasses.each do |klass|
      name = klass.to_s.underscore.pluralize
      puts "Building #{name}..."
      path = File.dirname(__FILE__) + "/../../config/categories/#{name}.yml"
      if File.exists?(path)
        klass.build(YAML.load(File.open(path)))
      end
    end
  end
  
  def self.subclasses
    [Activity, TimeSpan, GroupSize, Familiarity, Proximity]
  end

  def children?
    children.count > 0
  end
  
  def self.build(data)
    _build(data, nil, self)
  end

private
  def self._build(data, parent_id, klass)
    [data].flatten.each do |entry|
      case entry
      when String:
        klass.find_or_create! :parent_id => parent_id, :name => entry, :type => klass.to_s
      when Hash:
        entry.each do |k, v|
          inst = klass.find_or_create! :parent_id => parent_id, :name => k, :type => klass.to_s
          _build(v, inst.id, klass)
        end
      when YAML::DomainType:
        method = entry.type_id
        _build(klass.send(method), parent_id, klass)
      end
    end
  end

end