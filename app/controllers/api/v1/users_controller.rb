class Api::V1::UsersController < AuthenticatedController

  def index
    @users = User.all
    render json: @users
  end
end
