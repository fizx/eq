require "rubygems"
require "libxml"
class GmailParser
  include LibXML
  def parse(string)
    doc = XML::Document.string(string)
    doc.find("//gd:email").map {|n| n["address"]}
  end
end