class Location < ActiveRecord::Base
  acts_as_mappable :auto_geocode=>{ :field=>:name, :error_message=>'bad address'},
                   :distance_column_name => "radius"
end
