# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_gist/version"

Gem::Specification.new do |s|
  s.name        = "activegist"
  s.version     = ActiveGist::VERSION
  s.authors     = ["Colin MacKenzie IV"]
  s.email       = ["sinisterchipmunk@gmail.com"]
  s.homepage    = "http://github.com/sinisterchipmunk/active-gist"
  s.summary     = %q{Wraps GitHub's Gist API with an intuitive class based on ActiveModel.}
  s.description = %q{Wraps GitHub's Gist API with a class implementing the ActiveModel modules. So, it should be pretty familiar to anyone who's ever used models in Ruby on Rails.}

  s.rubyforge_project = "activegist"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", '~> 2.8'
  s.add_development_dependency "fakeweb", '~> 1.3'
  s.add_development_dependency 'rake', "~> 0.9"
  s.add_development_dependency 'rdoc', "~> 3.12"
  
  s.add_runtime_dependency "activemodel", '~> 4'
  s.add_runtime_dependency "activesupport", '~> 4'
  s.add_runtime_dependency "rest-client", '~> 1.6'
end
