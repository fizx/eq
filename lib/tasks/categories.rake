require "yaml"
require "pp"

namespace :categories do
  task :inspect do
    require "config/environment"
    Category.subclasses.each do |klass|
      name = klass.to_s.underscore.pluralize
      puts "Inspecting #{name}..."
      path = File.dirname(__FILE__) + "/../../config/categories/#{name}.yml"
      pp YAML.load(File.open(path))
    end
    
  end
  task :build do
    require "config/environment"
    Category.subclasses.each do |klass|
      name = klass.to_s.underscore.pluralize
      puts "Building #{name}..."
      path = File.dirname(__FILE__) + "/../../config/categories/#{name}.yml"
      klass.build(YAML.load(File.open(path)))
    end
  end
end