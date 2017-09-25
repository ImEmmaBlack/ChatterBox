class CreateParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :participants, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, index: true
      t.references :conversation, type: :uuid, foreign_key: true
      t.boolean :notifications, default: true
      t.boolean :active, default: true
      t.timestamp :active_since
      t.timestamps
    end
  end
end
