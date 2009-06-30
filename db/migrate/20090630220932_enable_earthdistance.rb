class EnableEarthdistance < ActiveRecord::Migration
  def self.up
    cmd = "find /opt/local/ -name earthdistance.sql | xargs cat | psql #{ActiveRecord::Base.connection.current_database}"
    puts cmd
    system cmd
  end

  def self.down
  end
end