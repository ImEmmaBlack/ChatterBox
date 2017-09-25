class CreateUsers < ActiveRecord::Migration[5.1]
  def self.up
    create_table :users, id: :uuid do |t|
      t.string :username,               null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string :password_digest, null: false, default: ""

      t.timestamps null: false
    end

    add_index :users, :email,             unique: true
    add_index :users, :id,                unique: true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
