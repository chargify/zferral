module Zferral
  # Raised when general resource errors are encountered.
  class ResourceError < StandardError
  end
  
  # Raised when a fetch request for a particular ID results in no resource being found.
  class ResourceNotFound < StandardError
  end
  
  # Raised when a particular Resource does not support the requested method
  class MethodNotSupported < StandardError
  end
end