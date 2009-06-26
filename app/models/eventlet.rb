class Eventlet < ActiveRecord::Base
  def self.match(url)
    find :first, :conditions => ["? ~ matcher", url]
  end
  
  def json
    attributes.inject({}) {|m, (k,v)|
      if %w[created_at updated_at matcher id].include?(k.to_s) || v.blank?
        m
      else
        m[k] = v
        m
      end
    }.to_json
  end
end
