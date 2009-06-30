ENV["RAILS_ENV"] = "development"
namespace :friends do
  task :create_random do
    require "config/environment"
    require "spec/girl"
    unless @user = User.find_by_login(ENV["USER"] || "kyle") 
      puts "no user"
      exit 1
    end
    20.times do 
      u = Factory(:user)
      20.times do
        i = u.new_interest
        u.interests << i
        i.save
        print "."
        STDOUT.flush
      end  
      u.save
      Following.create_friendship(@user, u)
    end
  end
end