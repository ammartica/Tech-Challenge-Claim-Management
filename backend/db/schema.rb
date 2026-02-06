# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_02_06_172155) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "claim_imports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "file_name"
    t.integer "total_records"
    t.integer "processed_records"
    t.string "status"
    t.datetime "created_at"
  end

  create_table "claims", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "patient_id"
    t.string "claim_number"
    t.date "service_date"
    t.decimal "amount"
    t.string "status"
    t.datetime "created_at"
    t.uuid "claim_import_id"
    t.index ["claim_import_id"], name: "index_claims_on_claim_import_id"
    t.index ["claim_number"], name: "index_claims_on_claim_number", unique: true
  end

  create_table "patients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.datetime "created_at"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "claims", "claim_imports"
end
