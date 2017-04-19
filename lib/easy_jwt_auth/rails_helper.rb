module EasyJwtAuth
  module RailsHelper
    def current_user
      auth_header = request.headers['Authorization']
      EasyJwtAuth::UserFinder.new.user_from_header(auth_header)
    rescue StandardError => e
      nil
    end
  end
end
