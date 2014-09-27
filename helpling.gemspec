# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'helpling/version'

Gem::Specification.new do |spec|
  spec.name          = 'helpling'
  spec.version       = Helpling::VERSION
  spec.authors       = ['Tate Johnson']
  spec.email         = ['tate@tatey.co']
  spec.summary       = %q{Helpers you wish were built into RSpec's request specs.}
  spec.description   = %q{Helpers you wish were built into RSpec's request specs.}
  spec.homepage      = 'https://github.com/tatey/helpling'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
