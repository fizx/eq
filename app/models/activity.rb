require "rubygems"
require "nokogiri"
require "open-uri"
class Activity < Category
  belongs_to :parent, :class_name => "Activity"
  has_many :children, :foreign_key => "parent_id", :class_name => "Activity"  
  
  def self.movie_list
    doc = Nokogiri::HTML(open("http://www.apple.com/trailers"))
    
    movies = []
    doc.css("#weekendboxoffice .title").each do |node|
      movies << node.content.strip.gsub(/^\d+\.\s*/, '')
    end
    doc.css("#openingthisweek .title").each do |node|
      movies << node.content.strip
    end
    if movies.length == 0
      raise "no movies extracted"
    end
    movies.map{|m| "watch #{m}" }
  rescue => e
    logger.error e.full_trace
    movies
  end
end
