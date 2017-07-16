# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/storage/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-storage"
  spec.version       = RSpec::Storage::VERSION
  spec.authors       = ["joker1007"]
  spec.email         = ["kakyoin.hierophant@gmail.com"]

  spec.summary       = %q{RSpec output test report to any stroage}
  spec.description   = %q{RSpec output test report to any stroage}
  spec.homepage      = "https://github.com/joker1007/rspec-storage"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rspec", "~> 3.3"

  spec.add_development_dependency "aws-sdk", ">= 2.0"
  spec.add_development_dependency "google-api-client", ">= 0.9"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
