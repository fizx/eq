class ActiveRecord::Migration
  def self.add_trgm_index(table, field)
    puts "Adding trgm index"
    ActiveRecord::Base.connection.execute("CREATE INDEX #{table}_#{field}_trgm_idx ON #{table} USING gist(#{field} gist_trgm_ops);")
  end
end

class ActiveRecord::Base
  def self.trgm_index(field)
    named_scope "#{field}_similar_to".to_sym, lambda {|text|
      escaped = text.gsub("\\", "\\\\").gsub("'", "\\'")
      {
        :select => "#{table_name}.*, similarity(#{table_name}.#{field}, '#{escaped}') AS sml",
        :conditions => "#{field} % '#{escaped}'",
        :order => "sml DESC, #{field}"
      }
    }
  end
end