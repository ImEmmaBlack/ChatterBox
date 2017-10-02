module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def auth_headers(user)
      {
        'CONTENT_TYPE' => 'application/json',
        'Authorization' => "bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}"
      }
    end
  end
end
