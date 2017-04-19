module EasyJwtAuth
  class Config
    class << self
      attr_reader :algo, :expiration, :finder_method, :secret

      def set_algo(algo)
        @algo = algo
      end

      def set_expiration(expiration)
        @expiration = expiration
      end

      def set_finder_method(finder_method)
        @finder_method = finder_method
      end

      def set_secret(secret)
        @secret = secret
      end
    end
  end
end
