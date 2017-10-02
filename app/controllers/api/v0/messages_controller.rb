class Api::V0::MessagesController < AuthenticatedController
  def index
    @messages = conversation.messages.order(created_at: :desc).page(page).per(results_per_page)
    render json: @messages
  end

  def create
    @message = conversation.messages.new(message_params.merge(user_id: current_user.id))
    if @message.save
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def conversation
    @conversation ||= current_user.conversations.find do |conversation|
      conversation.participants.find_by(user_id: params[:other_user_id]).exists? && conversation.participants.count == 2
    end || new_conversation
  end

  def new_conversation
    current_user.conversations.create.tap do |convo|
      convo.add_users([current_user, other_user])
    end
  end

  def other_user
    @other_user ||= User.find(params(:user_id))
  end

  def message_params
    params.require(:message).permit(:body, :url, :type_id)
  end

  def message_index_params
    params.permit(:page, :per)
  end

  def results_per_page
    [message_index_params[:per] || 20, Message::LIMIT].min
  end

  def page
    message_index_params[:page] || 1
  end
end
