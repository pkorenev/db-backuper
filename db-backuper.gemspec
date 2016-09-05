# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'db/backuper/version'

Gem::Specification.new do |spec|
  spec.name          = "db-backuper"
  spec.version       = Db::Backuper::VERSION
  spec.authors       = ["pasha"]
  spec.email         = ["p.korenev@voroninstudio.eu"]

  spec.summary       = %q{Db backuper}
  spec.description   = %q{backup rake tasks for postgres}
  spec.homepage      = "http://github.com"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir["**/*.rb"] + Dir["**/*.rake"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "lib/tasks"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
