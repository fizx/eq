require "yaml"
require "pp"

namespace :categories do
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