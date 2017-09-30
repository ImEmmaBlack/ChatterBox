class ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :active_since, :notifications, :active, :conversation_id
  belongs_to :user
end

