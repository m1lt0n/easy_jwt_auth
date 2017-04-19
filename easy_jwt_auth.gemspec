# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easy_jwt_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "easy_jwt_auth"
  spec.version       = EasyJwtAuth::VERSION
  spec.authors       = ["Pantelis Vratsalis"]
  spec.email         = ["pvratsalis@gmail.com"]

  spec.summary       = %q{Welcome to EasyJwtAuth! EasyJwtAuth is a ruby gem that allows easy use of JWT tokens in any ruby project or rails application, typically for authenticating and authorizing requests.}
  spec.description   = %q{A typical usecase of JWT tokens is when building an API. JWT tokens can be sent as authorization tokens in headers. The advantage of using JWT tokens is that they are signed with a secret, so the information inside them cannot be tampered. This makes them ideal for embeding both authentication and authorization information in one step (e.g. by "decoding" the token, one can get information about the user and the roles a user has in case of a role-based authorization). Also, the fact that expiration timestamps can be embedded in the data of the token and be handled automatically, can be used to easily build short-lived tokens, making an API more secure.}
  spec.homepage      = "https://github.com/m1lt0n/easy_jwt_auth"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_dependency "jwt", "~> 1.5"
end
