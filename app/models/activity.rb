require "rubygems"
require "nokogiri"
require "open-uri"
class Activity < Category
  
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
