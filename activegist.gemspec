# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_gist/version"

Gem::Specification.new do |s|
  s.name        = "activegist"
  s.version     = ActiveGist::VERSION
  s.authors     = ["Colin MacKenzie IV"]
  s.email       = ["sinisterchipmunk@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "activegist"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", '~> 2.8.0'
  s.add_development_dependency "fakeweb", '~> 1.3.0'
  s.add_runtime_dependency "activemodel", '~> 3.1.3'
end
