require "rubygems"
require 'httparty'
require 'json'
require 'hashie'

Dir[File.join(File.dirname(__FILE__), 'zferral', '**', '*.rb')].sort.each {|f| require f}

module Zferral #:nodoc:
  # Creates a new API {Zferral::Client} with the passed arguments.
  #
  # This is the preferred entry point for the library.  In other words, create a client using
  # this method and access all of the API resources from here.
  #
  #   zferral = Zferral.new(:subdomain => 'sandbox', :api_token => 'c143c5450fb633c70c53b1bcc6348077')
  #   zferral.campaign.list
  #
  # @param (see Zferral::Client#initialize)
  # @return (see Zferral::Client#initialize)
  def self.new(*args)
    Zferral::Client.new(*args)
  end
end