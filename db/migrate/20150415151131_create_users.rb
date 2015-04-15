class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, presence: true, null: false
      t.string :password_digest, presence: true, null: false
      t.string :session_token, presence: true

      t.timestamps null: false
    end

    add_index :users, :session_token, unique: true
  end
end
