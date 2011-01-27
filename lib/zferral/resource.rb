module Zferral
  # The "base" resource from which all of the Zferral API resources subclass.  This class typically
  # isn't used directly; instead, you'll use the subclasses like {Zferral::Campaign}.
  class Resource < Hashie::Mash
    include HTTParty
    format :json
    headers 'Content-Type' => 'application/json', 'Accept' => 'application/json'
    debug_output $stdout
    
    # Used to "connect" the resource to a Client already configured with credentials.
    #
    # Upon connection, the passed in Client is stored (see .client), the base_uri
    # for HTTParty interaction is calculated, and the class is returned.
    #
    # @param [Client] client instance with credentials (subdomain and api_token attached)
    #
    # @return [Class]
    def self.connect(client)
      @@client = client
      self.base_uri("https://#{subdomain}.zferral.com/api/#{api_token}")
      self
    end
    
    # @return [String] The subdomain of the currently connected Client, or nil of no Client is connected.
    def self.subdomain
      @@client.subdomain if @@client
    end

    # @return [String] The API token of the currently connected Client, or nil of no Client is connected.
    def self.api_token
      @@client.api_token if @@client
    end

    # @return [String] The singular resource name (computed from the class name) to be used in resource URLs
    def self.resource_name
      name.split("::").last.downcase
    end
    
    # @return [String] The plural resource name (computed from the class name) to be used in resource URLs
    def self.resource_names
      name.split("::").last.downcase + "s"
    end
    
    # Get an array of all members of the resource list
    #
    # @return [Array] An array of the expected resource
    def self.list
      handle_list get("/#{resource_names}.json")["#{resource_names}"]
    end
    
    # Alias .all to .list
    class << self
      alias_method :all, :list
    end

    # Fetches a single resource by ID
    #
    # @return [Resource] A single Resource object, or one of its subclasses
    #
    # @raise [ResourceError, ResourceNotFound]
    def self.fetch(id)
      fetch_id(id)
      handle_fetch get("/#{resource_name}/#{id}.json").parsed_response
    end
    
    # {Resource.find} can be used with syntax like ActiveRecord to fetch lists or single resources.
    #
    # To fetch a list, use the +:all+ parameter:
    # 
    #   Resource.find(:all)
    #
    # To fetch a single Resource, pass an Integer ID
    #
    # @param [Symbol, Integer] +:all+ to fetch a list, an Integer to fetch a single Resource
    #
    # @return [Array, Resource] An Array of Resources or a single Resource
    #
    # @raise (see .fetch)
    def self.find(scope_or_id)
      case scope_or_id
      when Symbol
        if scope_or_id == :all
          list
        end
      when Integer, String
        fetch(scope_or_id.to_i)
      end
    end
    
    private
    
    def self.client
      @@client
    end
    
    def self.handle_list(list)
      if list.is_a?(Array)
        list.collect { |c| self.new(c) }
      else
        raise Zferral::ResourceError, "unexpected response while listing #{resource_names}: #{list.inspect[0..20]}"
      end
    end
    
    def self.fetch_id(id=nil)
      @fetch_id = id unless id.nil?
      @fetch_id
    end
    
    def self.handle_fetch(response)
      case response
      when Hash
        case response.keys.first
        when resource_name
          resource = self.new(response[resource_name])
          if resource.respond_to?(:error)
            raise Zferral::ResourceError, resource.error
          end
          resource
        when 'error'
          code = response['error']['code']
          case code
          when '404'
            raise Zferral::ResourceNotFound, "#{resource_name} with id=#{fetch_id} was not found"
          else
            raise Zferral::ResourceError, "#{resource_name} caused a #{code} error"
          end
        else
          raise Zferral::ResourceError, "unexpected response: #{resource.inspect}" 
        end
      else
        raise Zferral::ResourceError, "unexpected response: #{resource.inspect}"
      end
    end
      
  end
end