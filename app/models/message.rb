class Message < ApplicationRecord
  TEXT_TYPE = 0
  IMAGE_TYPE = 1
  VIDEO_TYPE = 2
  TYPES = [TEXT_TYPE, IMAGE_TYPE, VIDEO_TYPE]

  QUERY_LIMIT = 20

  belongs_to :conversation
  belongs_to :user
  after_create :update_conversation, :set_metadata

  scope :since, ->(since_datetime, limit = QUERY_LIMIT) {
    where('created_at > ?', since_datetime)
      .order(created_at: :asc)
      .limit(limit) }

  scope :before, ->(before_datetime, limit = QUERY_LIMIT) {
    where('created_at < ?', before_datetime)
      .order(created_at: :desc)
      .limit(limit) }

  def update_conversation #TODO: queue up message update notifications to listeners
    conversation.update_latest_message_time(created_at)
  end

  def set_metadata #do this out of band irl probably?
    case type
    when IMAGE_TYPE
      update(metadata: { height: 200, width: 200 })
    when VIDEO_TYPE
      update(metadata: { source: 'youtube', length: 1.20 })
    end
  end
end

