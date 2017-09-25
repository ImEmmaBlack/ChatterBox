class CreateConversations < ActiveRecord::Migration[5.1]
  def change
    create_table :conversations, id: :uuid do |t|
      t.datetime :last_message_at
      t.timestamps
    end
  end
end
