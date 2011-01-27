require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Zferral::Campaign do
  use_vcr_cassette "campaigns"

  let(:campaign) { Zferral.new(:subdomain => subdomain, :api_token => api_token).campaign }

  describe "#list" do
    it "returns an array of your campaigns" do
      campaign.list.should be_an_array_of_campaigns
    end
    
    it "is aliased by #all" do
      campaign.all.should == campaign.list
    end
    
    it "is aliased by #find(:all)" do
      campaign.find(:all).should == campaign.list
    end
  end
  
  describe "#fetch" do
    context "given a valid ID" do
      it "fetches and returns the campaign" do
        campaign.fetch(1).should be_a_campaign
      end
    end
    context "given an invalid ID" do
      it "raises a ResourceNotFound exception" do
        lambda { campaign.fetch(9999999) }.should raise_error(Zferral::ResourceNotFound, "campaign with id=9999999 was not found")
      end
    end
    
    it "is aliased by #find(id)" do
      campaign.find(1).should == campaign.fetch(1)
    end
  end
end
