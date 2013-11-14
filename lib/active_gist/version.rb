class ActiveGist
  module Version
    MAJOR, MINOR, TINY = 0, 7, 1
    STRING = [MAJOR, MINOR, TINY].join '.'
  end
  
  VERSION = ActiveGist::Version::STRING
end
