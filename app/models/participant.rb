class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :conversation


  def mark_active
    update(active: true, active_since: Time.now.utc)

  end
  def mark_inactive
    update(active: false)
  end
end
