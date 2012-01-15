$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'active_gist'
Dir[File.expand_path('support/**/*.rb', File.dirname(__FILE__))].each { |f| require f }

