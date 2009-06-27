class ActiveRecord::Base
  def self.random
    find :first, :offset => rand(count), :limit => "1"
  end
end