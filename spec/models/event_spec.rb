require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  before do 
    @fb = Marshal.load(File.read(File.dirname(__FILE__) + "/../fixtures/facebook_data.dump"))
  end
  
  describe "#populate_facebook" do
    it "should create events" do
      @fb[:events].should be_an(Array)
      @events = Event.populate(@fb[:events])
      @events.should be_an(Array)
      @events.each do |e|
        e.should be_an(::Event)
        e.should_not be_new_record
      end
      @fb[:events].length.should == @events.length
    end
  end
end
