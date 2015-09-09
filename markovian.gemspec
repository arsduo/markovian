# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'markovian/version'

Gem::Specification.new do |spec|
  spec.name          = "markovian"
  spec.version       = Markovian::VERSION
  spec.authors       = ["Alex Koppel"]
  spec.email         = ["alex@alexkoppel.com"]

  spec.summary       = %q{A simple, hopefully easy-to-use Markov chain generator.}
  spec.description   = %q{A simple, hopefully easy-to-use Markov chain generator.}
  spec.homepage      = "https://github.com/arsduo/markov-ahkoppel"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
