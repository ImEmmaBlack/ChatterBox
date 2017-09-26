class SignUpController < ActionController::API
  def create
    @user = User.new(user_params)
    if @user.save
      render json: user_hash.merge({ jwt: auth_token.token })
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:sign_up).permit(:username, :email, :password, :password_confirmation)
  end

  def user_hash
    @user.serializable_hash(only: [:id, :username, :email])
  end

  def auth_token
    Knock::AuthToken.new(payload: { sub: @user.id })
  end
end

