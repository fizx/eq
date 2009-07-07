namespace :cal do
  task :fetch do
    require "config/environment"
    WebCalendar.each do |wc|
      wc.fetch_later
      print "."
      STDOUT.flush
    end
    puts
  end
end