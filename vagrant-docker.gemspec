# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-docker/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-docker"
  spec.version       = VagrantPlugins::Docker::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Pritesh Mehta"]
  spec.email         = ["pritesh@phatforge.com"]
  spec.description   = %q{Enable vagrant to manage machines in docker}
  spec.summary       = %q{Enable vagrant to manage machines in docker}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency     "docker-api", "~> 1.5.4"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-core", "~> 2.12.2"
  spec.add_development_dependency "rspec-expectations", "~> 2.12.1"
  spec.add_development_dependency "rspec-mocks", "~> 2.12.1"
  spec.add_development_dependency "pry"

end
