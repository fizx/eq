require File.dirname(__FILE__) + '/../spec_helper'

describe GmailParser do
  before do
    @p = GmailParser.new
    @atom = File.read(File.dirname(__FILE__) + "/../fixtures/contacts.atom")
  end
  
  describe "#parse" do
    it "should return contacts" do
      emails = @p.parse(@atom)
      emails.should be_an(Array)
      emails.length.should == 25
    end
  end
  
end
