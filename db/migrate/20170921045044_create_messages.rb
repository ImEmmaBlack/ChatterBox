class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, index: true
      t.references :conversation, type: :uuid, foreign_key: true, index: true
      t.text :body, null: false, default: ''
      t.string :url
      t.integer :type_id, null: false, default: 0
      t.jsonb :metadata

      t.timestamps
    end
    add_index :messages, [:created_at]
  end
end
