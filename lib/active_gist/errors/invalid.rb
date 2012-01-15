module ActiveGist::Errors
  # Raised when a gist raises validation errors during a call to ActiveGist#save!
  class Invalid < StandardError
  end
end
