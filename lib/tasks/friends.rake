ENV["RAILS_ENV"] = "development"
namespace :friends do
  task :create_random do
    require "config/environment"
    require "spec/girl"
    User.delete_all
    @user = Factory(:user, :login => "kyle", 
                    :password => "hiworld", 
                    :password_confirmation => "hiworld")
    20.times do |k|
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