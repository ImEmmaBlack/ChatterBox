class Api::V1::UsersController < AuthenticatedController
  before_action :set_user, only: [:show]

  def index
    @users = User.all
    render json: @users
  end

  def search
    @users = User.find_by_fuzzy_username(params[:search_text], limit: 10)
    render json: @users
  end

  def show
    render json: @user
  end


  private
  def set_user
    @user = User.find(params[:id])
  end
end
