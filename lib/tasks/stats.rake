require "active_support"
task :loc do
  s = `rake stats`
  locs = s.scan(/LOC:\s+(\d+)/).flatten.map(&:to_i).sum
  puts (locs + `find app/views/ -type f | xargs cat | wc -l`.to_i).inspect
end