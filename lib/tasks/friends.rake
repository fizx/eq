ENV["RAILS_ENV"] = "development"
namespace :friends do
  task :create_random do
    require "config/environment"
    require "spec/girl"
    User.delete_all
    Location.delete_all
    @user = Factory(:user, :login => "kyle", 
                    :password => "hiworld", 
                    :password_confirmation => "hiworld")
    20.times do |k|
      u = Factory(:user)
      20.times do
        i = PositiveInterest.new 
        i.activity = Activity.all.rand
        i.time_span = TimeSpan.all.rand
        i.familiarity = Familiarity.all.rand
        i.group_size = GroupSize.all.rand
        i.proximity = Proximity.find_or_create!(:location_id => u.default_location.id, :radius => 10)
        u.interests << i
        i.save!
        print "."
        STDOUT.flush
      end  
      u.save
      Following.create_friendship(@user, u)
    end
  end
end