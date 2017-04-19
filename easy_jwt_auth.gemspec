# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easy_jwt_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "easy_jwt_auth"
  spec.version       = EasyJwtAuth::VERSION
  spec.authors       = ["Pantelis Vratsalis"]
  spec.email         = ["pvratsalis@gmail.com"]

  spec.summary       = %q{easy_jwt_auth is a small gems that can be used in APIs and allows authentication with the use of jwt tokens.}
  spec.description   = %q{With easy_jwt_auth, a client can send a jwt token as the authorization header and the gem will check this header and load the appropriate user if the token is valid and has not expired}
  spec.homepage      = "https://github.com/m1lt0n/easy_jwt_auth"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_dependency "jwt", "~> 1.5"
end
