require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Zferral::Event do
  use_vcr_cassette "events", :match_requests_on => [:uri, :method, :body]

  let(:event) { Zferral.new(:subdomain => subdomain, :api_token => api_token).event }
  
  describe "#call" do
    context "passing all required params, with debug" do
      it "returns an event containing the commission_sum" do
        resource = event.call(:debug => '1', :campaign_id => 1, :revenue => 20.00, :customer_id => "1", :affiliate_id => 538)
        resource.should respond_to(:commission_sum)
      end
    end
    
    context "with a missing campaign_id" do
      it "raises a ResourceError with the error displayed" do
        lambda {
          event.call(:debug => '1', :revenue => 20.00, :customer_id => "1", :affiliate_id => 538)
        }.should raise_error(Zferral::ResourceError, "Campaign ID is not set.")
      end
    end

    context "with none of the required parameters" do
      it "raises a ResourceError with the first encountered error displayed" do
        lambda {
          event.call(:debug => '1')
        }.should raise_error(Zferral::ResourceError, "Campaign ID is not set.")
      end
    end
  end
  
  describe "#call_recurring" do
    it "invokes call after merging the option to ignore the cookie" do
      hash = {:debug => '1', :campaign_id => 1, :revenue => 20.00, :customer_id => "1", :affiliate_id => 538}
      event.should_receive(:call).with(hash.merge(:ignore_cookie => '1'))
      event.call_recurring(hash)
    end
    
    it "posts the event successfully without passing an affiliate id if the customer_id is previously 'registered'" do
      resource = event.call_recurring(:debug => '1', :campaign_id => 1, :revenue => 20.00, :customer_id => "1")
      resource.should respond_to(:commission_sum)
    end

    it "posts the event unsuccessfully without passing an affiliate id if the customer_id is not previously 'registered'" do
      lambda {
        event.call_recurring(:debug => '1', :campaign_id => 1, :revenue => 20.00, :customer_id => "foobarjones")
      }.should raise_error(Zferral::ResourceError, "Neither cookie found nor referer set.")
    end

  end
end
