require "rubygems"
require "libxml"
class GmailParser
  include LibXML
  
  def initialize(client)
    @client = client
  end
  
  def parse(uri)
    string = @client.get(uri).body
    doc = XML::Document.string(string)
    
    output = doc.find("//gd:email").map {|n| n["address"]}
    others = doc.find("//atom:link[@rel='next']", "atom:http://www.w3.org/2005/Atom").map {|n|
        parse n["href"]
       }
    (output + others).flatten.uniq
  rescue => e
    STDERR.puts e.message
    STDERR.puts e.backtrace.join("\n")
    []
  end
end