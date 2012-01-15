require 'rest-client'

module ActiveGist::API
  class << self
    def username
      @username
    end
    
    def password
      @password
    end
    
    def username=(username)
      @username = username
    end
    
    def password=(password)
      @password = password
    end
  end
  
  def username
    ActiveGist::API.username
  end
  
  def password
    ActiveGist::API.password
  end
  
  def api
    @api ||= RestClient::Resource.new("https://api.github.com/gists", username, password)
  end
end
