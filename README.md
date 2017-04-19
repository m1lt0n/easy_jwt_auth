# EasyJwtAuth

Welcome to EasyJwtAuth! EasyJwtAuth is a ruby gem that allows easy use of JWT tokens in any ruby project or rails application, typically for authenticating and authorizing requests.

A typical usecase of JWT tokens is when building an API. JWT tokens can be sent as authorization tokens in headers. The advantage of using JWT tokens is that they are signed with a secret, so the information inside them cannot be tampered. This makes them ideal for embeding both authentication and authorization information in one step (e.g. by "decoding" the token, one can get information about the user and the roles a user has in case of a role-based authorization). 

Also, the fact that expiration timestamps can be embedded in the data of the token and be handled automatically, can be used to easily build short-lived tokens, making an API more secure.


## Dependencies

The only dependency of EasyJwtAuth is the [jwt gem](https://github.com/jwt/ruby-jwt).

## Installation

### Using rubygems

```ruby
gem install easy_jwt_auth
```

### Using bundler

Add the following to your Gemfile
```ruby
gem 'easy_jwt_auth'
```
and the run
```bash
bundle install
```

## Usage

#### In Rails projects
For Rails project, the only real configuration needed is to create an initializer (e.g. easy_jwt_auth.rb):

#### Setup
```ruby
EasyJwtAuth::Config.tap do |c|
  c.set_expiration 3600 # expiration of jwt token in seconds
  c.set_algo 'HS256' # the algorithm used for signing the data
  c.set_secret 's3cr3t' # the secret to use for signing the data
  c.set_finder_method ->(id) { User.find(id) }
end
```
The first 3 configuration settings are self explanatory, but in short:
* **set_expiration** is used to set the expiration of the token in seconds. If a token is expired, it will be treated as invalid
* **set_algo is** used to set the algorithm used for signing the payload of the JWT token
* **set_secret** is used to set secret used in the algorithm for signing the paylod

The **set_finder_method** setting accepts an object that responds to the call method, so either an object can be passed or a lambda function as in the example. This eliminates the dependency of easy_jwt_auth on ActiveRecord and allows you have a model different than User or even get users via repositories. The only requirement of set_finder_method is to be set to an object that responds to call and accepts an id argument (though if you're using ActiveRecord, it's not mandatory to be the id of the model, it can be an email address, a uuid, whatever).

That's it! This is the only setup needed. EasyJwtAuth comes with a couple of useful helper methods for Rails. To use them in your controllers, just include them in your ApplicationController. For example:

#### Helpers

```ruby
class ApplicationController < ActionController::API
  include EasyJwtAuth::RailsHelpers
end
```

With this line of code you have gained access to 2 methods:
* **jwt_current_user** which gets the Authorization header from the request and finds the user associated with this header (based on the finder method of the configuration step). The result of the jwt_current_user is memoized, so you can use it as many times as you wish without performing extra database queries or expensive operations.
* **jwt_authenticate!** which returns a 403 forbidden response with empty response body in case there is no jwt_current_user. This method is useful for authorizing requests to routes you wish to protect as a before_action filter.

Examples:

The code below protects the my_secret_route action against non-authorized requests:

```ruby
class SecretController < ApplicationController
  before_action :jwt_authenticate!, only: [:my_secret_route]
  
  # this action needs an authorization header with a proper token
  def my_secret_route
    render json: { 'user_id': jwt_current_user.id }, status: :ok
  end
  
  # this action does not
  def other_route
    render json: {}, status: :ok
  end
end
```

#### Generating tokens

In order to generate a jwt token, you can use the EasyJwtAuth::TokenBuilder's build_token method. The method accepts an id (either the id of the user, which it stores in the token and is used by the finder method of the user finder and jwt_current_user method).

Example:

```ruby
class LoginController < ApplicationController
  def login
    # login logic, eg validate credentials from a login form and find the user
    token_builder = EasyJwtAuth::TokenBuilder.new
    render json: { token: token_builder.build_token(user.id) }, status: :ok
  end
end
```

In the example above, the token is returned by the API and can be used for subsequent calls to protected resources (by setting the Authorization header in subsequent requests as "Bearer token_value").

#### Outside of Rails projects
The gem includes a couple of helpers that can be used only in Rails projects, but the rest of the classes can be used by any other project. Specifically:

**EasyJwtAuth::Config**
This is the only requirement in order to configure the gem. The configuration is quite simple. This is common both for Rails and non-Rails projects (for more information see Setup section for Rails projects above).

**EasyJwtAuth::TokenBuilder**
The token builder can be used to generate new tokens. The Config setup should come first before using any of the other classes (like the TokenBuilder). Example:

```ruby
token_builder = EasyJwtAuth::TokenBuilder.new

# the argument passed is the id used for finding the user by the finder_method configured in the setup step.

# the id could be a model id
token_builder.build_token(50)

# or an email address for example
token_builder.build_token('john@example.com')
```

**EasyJwtAuth::UserFinder**
The UserFinder is used to retrieve a user based on the authorization header of the request. The authorization header should be in the form "Bearer token_value". The UserFinder extracts the token_value and finds the id of the user and uses that in order to retrieve the user (by using the finder_method of the setup step).

Example:

```ruby
# let's build a token
token_builder = EasyJwtAuth::TokenBuilder.new
token = token_builder.build_token(50)

header = "Bearer #{token}"
uf = EasyJwtAuth::UserFinder.new
user = uf.user_from_header(header)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/m1lt0n/easy_jwt_auth. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

