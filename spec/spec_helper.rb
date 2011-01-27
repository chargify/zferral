$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'vcr'
require 'webmock/rspec'
require 'zferral'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end

VCR.config do |c|
  c.cassette_library_dir     = 'spec/vcr_cassettes'
  c.stub_with                :webmock
  c.default_cassette_options = { :record => :new_episodes }
end

def test_credentials
  @test_credentials ||= {'subdomain' => subdomain, 'api_token' => api_token}
end

def subdomain
  'sandbox'
end

def api_token
  'c143c5450fb633c70c53b1bcc6348077'
end
  