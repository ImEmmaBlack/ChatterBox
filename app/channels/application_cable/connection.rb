module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if verified_user = find_user
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def token_from_request_headers
      unless request.headers['Authorization'].nil?
        request.headers['Authorization'].split.last
      end
    end

    def token
      request.params[:jwt] || token_from_request_headers
    end

    def find_user
      Knock::AuthToken.new(token: token).entity_for(User)
    rescue Knock.not_found_exception_class, JWT::DecodeError
      nil
    end
  end
end
