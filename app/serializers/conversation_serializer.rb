class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :last_message_at
  has_many :participants
  has_many :users
end
