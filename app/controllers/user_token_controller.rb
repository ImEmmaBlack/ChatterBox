class UserTokenController < Knock::AuthTokenController
  def create
    render json: user_hash.merge({ jwt: auth_token.token }), status: :created
  end

  private

  def user_hash
    entity.serializable_hash(only: [:id, :username, :email])
  end

  def auth_params
    params.permit :email, :password
  end
end
