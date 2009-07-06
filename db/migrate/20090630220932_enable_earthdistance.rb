class EnableEarthdistance < ActiveRecord::Migration
  def self.up
    path = `uname` =~ /darwin/i ? "/opt/local" : "/"
    cmd = "find #{path} -name earthdistance.sql | xargs cat | psql #{ActiveRecord::Base.connection.current_database}"
    puts cmd
    system cmd
  end

  def self.down
  end
end