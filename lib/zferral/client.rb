module Zferral
  # The Client holds the API credentials and orchestrates access to the Resources.
  class Client
    attr_accessor :subdomain
    attr_accessor :api_token

    # @param [Hash] options API credentials, passed as a hash with 'subdomain' and 'api_token' keys
    def initialize(options = {})
      self.subdomain = options[:subdomain] || options['subdomain']
      self.api_token = options[:api_token] || options['api_token']
    end
    
    # A {Zferral::Campaign} class connected to this Client
    #
    # @return [Zferral::Campaign]
    def campaign
      Zferral::Campaign.connect(self)
    end
    
    # A {Zferral::Campaign} resource for this Client
    #
    # @return [Zferral::Campaign] {Zferral::Campaign} class
    def campaign
      Zferral::Campaign.connect(self)
    end
    
    # A {Zferral::Event} resource for this Client
    #
    # @return [Zferral::Event] {Zferral::Event} class
    def event
      Zferral::Event.connect(self)
    end
  end
end