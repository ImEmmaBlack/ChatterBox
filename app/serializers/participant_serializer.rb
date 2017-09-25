class ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :active_since, :notifications, :active, :active_since, :conversation_id
  belongs_to :user
end

