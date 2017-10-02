class Message < ApplicationRecord
  TEXT_TYPE = 0
  IMAGE_TYPE = 1
  VIDEO_TYPE = 2
  TYPES = [TEXT_TYPE, IMAGE_TYPE, VIDEO_TYPE]

  QUERY_LIMIT = 60

  belongs_to :conversation
  belongs_to :user
  after_create :notify
  after_commit :update_conversation, :set_metadata

  validates :type_id, inclusion: TYPES
  validates :body, presence: true, if: :text?
  validates :url, presence: true, if: :media?

  scope :since, -> (since_datetime, limit = QUERY_LIMIT) {
    where('created_at > ?', since_datetime)
      .order(created_at: :asc)
      .limit(limit) }

  scope :before, -> (before_datetime, limit = QUERY_LIMIT) {
    where('created_at < ?', before_datetime)
      .order(created_at: :desc)
      .limit(limit).reverse }

  def image?
    type_id == IMAGE_TYPE
  end

  def video?
    type_id == VIDEO_TYPE
  end

  def text?
    type_id == TEXT_TYPE
  end

  def media?
    [IMAGE_TYPE, VIDEO_TYPE].include? type_id
  end

  private

  def update_conversation
    conversation.update_latest_message_time(created_at)
  end

  def set_metadata
    case type_id
    when IMAGE_TYPE
      update(metadata: { height: 200, width: 200 })
    when VIDEO_TYPE
      update(metadata: { source: 'youtube', length: 1.20 })
    end
  end

  def notify
    conversation.notify_all_participants_new_message(id, user_id)
  end
end
