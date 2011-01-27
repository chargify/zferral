module Zferral
  # A Zferral Event Resource
  #
  # http://zferral.com/api-docs/event
  class Event < Resource
    # The event/call API method, used to register an event (i.e. sale)
    def self.call(params = {})
      response = post("/event/call.json", :body => {:event => params}.to_json).parsed_response
      handle_fetch response
    end
    
    # A special invocation of the event/call API method, used to register recurring revenue events.
    #
    # These calls add the +ignore_cookie+ flag, so that an affiliate ID or cookie is not needed.
    # Instead, the affiliate to credit is identified by the +customer_id+ attribute, assuming that
    # the +customer_id+ has been associated with the Affiliate already via a normal .call method
    # or via the Zferral tracking code (img tag or javascript).
    def self.call_recurring(params = {})
      params.merge!(:ignore_cookie => '1')
      call(params)
    end
    
    # Not supported by Event
    def self.list
      raise MethodNotSupported, "Event does not support the .list method"
    end

    # Not supported by Event
    def self.fetch(id)
      raise MethodNotSupported, "Event does not support the .fetch method"
    end
  end
end