module EasyJwtAuth
  class TokenBuilder
    def initialize
      @algo = Config.algo
      @expiration = Config.expiration
      @secret = Config.secret
    end

    def build_token(id)
      iat = Time.now.to_i
      exp = iat + expiration
      payload = { id: id, iat: iat, exp: exp }

      JWT.encode(payload, secret, algo)
    end

    private

    attr_reader :algo, :expiration, :secret
  end
end
