class Api::V1::MessagesController < AuthenticatedController
  def index
    if message_index_params[:since]
      @messages = conversation.messages.since(since_datetime, limit)
    else
      @messages = conversation.messages.before(before_datetime, limit)
    end
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
    @conversation ||= current_user.conversations.find(params[:conversation_id])
  end

  def earliest_visible_message_time
    conversation.participant(current_user.id).active_since
  end

  def since_datetime
    [message_index_params[:since] || 0,  earliest_visible_message_time].max
  end

  def before_datetime
    [message_index_params[:before] || Time.now.utc, earliest_visible_message_time || Time.now.utc].min
  end

  def limit
    [message_index_params[:limit] || Message::QUERY_LIMIT, Message::QUERY_LIMIT].min
  end

  def set_message
    @message = conversation.messages.find(params[:message_id])
  end

  def message_params
    params.require(:message).permit(:body, :url, :type_id)
  end

  def message_index_params
    params.permit(:since, :before, :limit)
  end
end
