class Location < ActiveRecord::Base
  trgm_index :name
  validates_uniqueness_of :name unless RAILS_ENV == "test"
  acts_as_mappable :auto_geocode=>{ :field=>:name, :error_message=>'bad address'},
                   :distance_column_name => "radius"
                   
  named_scope :valid, {
    :conditions => {:geocodable => true}
  }
                   
  def self.from(string)
    return nil unless string
    return nil if string == "N/A"
    if loc = find_by_name 
      return loc
    else
      loc = Location.create(:name => string, :geocodable => true) 
      if loc.new_record?
        loc.geocodable = false
        loc.save(false)
      end
      return loc
    end
  end
end
