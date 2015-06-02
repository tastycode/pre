# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pre/version"

Gem::Specification.new do |s|
  s.name        = "pre"
  s.version     = Pre::VERSION
  s.authors     = ["Thomas Devol"]
  s.email       = ["thomas.devol@gmail.com"]
  s.homepage    = "http://www.github.com/vajrapani666/pre"
  s.summary     = %q{Pretty reliable email validator}
  s.description = %q{Checks email using RFC2822 compliant parser, Requests MX records for server validation. Supports caching}

  s.rubyforge_project = "pre"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  ["rspec", "mocha", "pry-nav"].each {|lib| s.add_development_dependency lib}
  s.add_runtime_dependency "treetop"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "dalli"
end
