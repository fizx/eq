require "rubygems"
require "nokogiri"
require "open-uri"
class Activity < Category
  
  has_many :interests, :dependent => :destroy
  
  def self.interest_cache
    @interest_cache ||= proc {
      time_spans = TimeSpan.find(:all, :select => "id, type", :conditions => {:type => "TimeSpan"}).map(&:id)
      activities = Activity.find(:all, :select => "id, type", :conditions => {:type => "Activity"}).map(&:id)
      tmp = []
      activities.each{|a| time_spans.each{|t| tmp << [a, t]} }
      tmp
    }.call
  end
  
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
