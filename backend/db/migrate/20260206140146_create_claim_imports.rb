class CreateClaimImports < ActiveRecord::Migration[7.1]
  def change
    create_table :claim_imports, id: :uuid do |t|
      t.string :file_name
      t.integer :total_records
      t.integer :processed_records
      t.string :status
      t.datetime :created_at
    end
  end
end
