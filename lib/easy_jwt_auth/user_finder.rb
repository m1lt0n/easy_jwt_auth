module EasyJwtAuth
  class UserFinder
    def initialize
      @algo = Config.algo
      @finder_method = Config.finder_method
      @secret = Config.secret
    end

    def user_from_header(auth_header)
      decoded_token = JWT.decode(
        token_from_header(auth_header), secret, true, { algorithm: algo }
      )

      data = decoded_token.first
      finder_method.call(data['id'])
    end

    private

    attr_reader :algo, :secret, :finder_method

    def token_from_header(auth_header)
      auth_header.split.last
    end
  end
end
