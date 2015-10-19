# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simply_suggest/version'

Gem::Specification.new do |spec|
  spec.name          = "simply_suggest"
  spec.version       = SimplySuggest::VERSION
  spec.authors       = ["Simply Suggest"]
  spec.email         = ["info@simply-suggest.com"]
  spec.summary       = %q{Api for www.simply-suggest.com here}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = `git ls-files -- {spec}/*`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'actionpack', '>= 3.0.0'
  spec.add_dependency 'faraday'

  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
