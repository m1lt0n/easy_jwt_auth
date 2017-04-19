module EasyJwtAuth
  module RailsHelper
    def jwt_current_user
      return @_jwt_current_user if defined?(@_jwt_current_user)

      auth_header = request.headers['Authorization']
      @_jwt_current_user = EasyJwtAuth::UserFinder.new.user_from_header(auth_header)
    rescue StandardError => e
      nil
    end

    def jwt_authenticate!
      head(403) if jwt_current_user.nil?
    end
  end
end
