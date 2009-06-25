class Category < ActiveRecord::Base
  
  def self.all
    find_all_by_type(self.to_s)
  end
  
  def self.subclasses
    [Activity, TimeSpan, GroupSize, Familiarity, Proximity]
  end

  def self.all_roots
    find_all_by_parent_id(nil)
  end

  def self.build(data)
    _build(data, nil, self)
  end

private
  def self._build(data, parent_id, klass)
    puts klass.to_s
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