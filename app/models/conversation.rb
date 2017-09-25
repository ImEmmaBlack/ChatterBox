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

  def mark_inactive(user_id)
    participant(user_id).mark_inactive
  end

  def update_latest_message_time(latest_message_time)
    conversation.update(latest_message_at: created_at) if latest_message_time > latest_message_at
  end
end