class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.datetime :created_at
    end
  end
end
