# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'status-manager/version'

Gem::Specification.new do |spec|
  spec.name          = "status-manager"
  spec.version       = StatusManager::VERSION
  spec.date          = "2014-04-10"
  spec.authors       = ["keepcosmos"]
  spec.email         = ["keepcosmos@gmail.com"]
  spec.description   = "ActiveRecord Model Status Manager"
  spec.summary       = "ActiveRecord Model Status Manager, It provides easy ways for managing ActiveModels that have many statuses."
  spec.homepage      = "https://github.com/keepcosmos/status-manager"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
