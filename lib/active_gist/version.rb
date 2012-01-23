class ActiveGist
  module Version
    MAJOR, MINOR, TINY = 0, 6, 3
    STRING = [MAJOR, MINOR, TINY].join '.'
  end
  
  VERSION = ActiveGist::Version::STRING
end
