# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resolve/version'

Gem::Specification.new do |spec|
  spec.name                  = "resolve"
  spec.version               = Resolve::VERSION
  spec.authors               = ["Sam Taylor"]
  spec.email                 = ["sjltaylor@gmail.com"]
  spec.description           = %q{Dependency Injection helpers}
  spec.summary               = %q{A was to define dependencies of a class and resolve services with dependencies fullfilled}
  spec.homepage              = "https://github.com/sjltaylor/resolve"
  spec.license               = "MIT"
  spec.required_ruby_version = '>= 2.1.1'

  spec.files                 = `git ls-files`.split($/)
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
end
