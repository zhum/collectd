# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collectd/version'

Gem::Specification.new do |spec|
  spec.name          = "collectd"
  spec.version       = Collectd::VERSION
  spec.authors       = ["Charlie Revett, Stephan Maka"]
  spec.email         = ["charlierevett@gmail.com"]
  spec.summary       = %q{Send collectd metrics from Ruby.}
  spec.homepage      = "https://github.com/revett/collectd"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rspec-nc"

  spec.add_runtime_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "rake-rspec"
  spec.add_runtime_dependency "rspec", "~> 3.1"
end
