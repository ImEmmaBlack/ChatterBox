class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages_for_user_#{current_user.id}"
  end
end
