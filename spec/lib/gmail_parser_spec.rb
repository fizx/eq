require File.dirname(__FILE__) + '/../spec_helper'

class MockClient
  def initialize
    @responses = [
      OpenStruct.new(:body => File.read(File.dirname(__FILE__) + "/../fixtures/contacts.atom")),
      OpenStruct.new(:body => File.read(File.dirname(__FILE__) + "/../fixtures/contacts2.atom"))
    ]
  end
  
  def get(url)
    @responses.shift
  end
end

describe GmailParser do
  before do
    client = MockClient.new
    @p = GmailParser.new(client)
  end
  
  describe "#parse" do
    it "should return contacts" do
      emails = @p.parse(@atom)
      emails.should be_an(Array)
      emails.length.should == 27 # only 2 unique in contacts2
    end
  end
  
end
