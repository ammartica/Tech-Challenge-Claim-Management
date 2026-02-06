class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :password_digest
      t.string :role
      t.datetime :created_at
    end
    add_index :users, :email, unique: true
  end
end
