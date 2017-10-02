class Api::V1::ConversationsController < AuthenticatedController
  before_action :set_conversation, only: [:update]

  def index
    @conversations = current_user.conversations.all
    render json: @conversations
  end

  def show
    render json: @conversation
  end

  def create
    @conversation = current_user.conversations.new()
    users = user_ids.map { |user_id| User.find(user_id) }
    if @conversation.save && @conversation.add_users(users << current_user)
      @conversation.notify_all_participants_new_conversation
      render json: @conversation
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  def update
    users = user_ids.map { |user_id| User.find(user_id) }
    if @conversation.add_users(users.push(current_user))
      render json: @conversation
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  private
  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end

  def user_ids
    params.require(:conversation).permit(user_ids: [])[:user_ids]
  end
end
