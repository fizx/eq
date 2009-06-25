require "yaml"
require "pp"
path = File.dirname(__FILE__) + "/../../config/activities.yml"
data = YAML.load(File.open(path))

namespace :activities do
  task :build do
    Activity.build(data)
  end
  
  task :inspect do
    pp data
  end
end