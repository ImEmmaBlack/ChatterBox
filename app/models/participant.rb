class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  after_initialize :set_active_now

  def set_active_now
    self.active = true
    self.active_since = Time.current
  end
end
