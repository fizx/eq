class Location < ActiveRecord::Base
  trgm_index :name
  validates_uniqueness_of :name unless RAILS_ENV == "test"
  acts_as_mappable :auto_geocode=>{ :field=>:name, :error_message=>'bad address'},
                   :distance_column_name => "radius"
                   
  def self.from(string)
    return nil unless string
    return nil if string == "N/A"
    find_or_create_by_name(string) 
  end
end
