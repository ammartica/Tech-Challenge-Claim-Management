class CreateClaims < ActiveRecord::Migration[7.1]
  def change
    create_table :claims, id: :uuid do |t|
      t.uuid :patient_id
      t.string :claim_number
      t.date :service_date
      t.decimal :amount
      t.string :status
      t.datetime :created_at
    end
    add_index :claims, :claim_number, unique: true
  end
end
