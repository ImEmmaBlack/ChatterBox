class Conversation < ApplicationRecord
  has_many :messages
  has_many :participants
  has_many :users, through: :participants

  def add_users(users)
    users.all? { |user| add_user(user) }
  end

  def add_user(user)
    participants.create(user: user)
  end

  def participant(user_id)
    participants.find_by(user_id: user_id)
  end

  def update_latest_message_time(latest_message_time)
    update(last_message_at: latest_message_time) if last_message_at.nil? || latest_message_time > last_message_at
  end

  def notify_all_participants_new_message(message_id, sender_id)
    participants.each do |participant|
      ActionCable.server.broadcast "messages_for_user_#{participant.user_id}",
      message_id: message_id,
      conversation_id: id,
      sender_id: sender_id
    end
  end

  def notify_all_participants_new_conversation
    reload.participants.each do |participant|
      ActionCable.server.broadcast "messages_for_user_#{participant.user_id}",
        conversation_id: id
    end
  end
end
