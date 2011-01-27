require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zferral" do
  describe ".new" do
    it "creates a new instance of Zferral::Client" do
      Zferral.new.should be_a(Zferral::Client)
    end
  end
  
  describe "#campaign" do
    it "provides access to the Campaign class with a linkage to the client" do
      zferral = Zferral.new(:subdomain => subdomain, :api_token => api_token)
      zferral.campaign.should == Zferral::Campaign
      zferral.campaign.client.should == zferral
    end
  end

  describe "#event" do
    it "provides access to the Event class with a linkage to the client" do
      zferral = Zferral.new(:subdomain => subdomain, :api_token => api_token)
      zferral.event.should == Zferral::Event
      zferral.event.client.should == zferral
    end
  end
end

