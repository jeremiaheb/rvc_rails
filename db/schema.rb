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

ActiveRecord::Schema[8.0].define(version: 2025_06_20_185157) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "data_file_analytics", force: :cascade do |t|
    t.date "date", null: false
    t.string "ip_address", null: false
    t.string "data_type", null: false
    t.integer "year", null: false
    t.string "region", null: false
    t.string "format", null: false
    t.integer "count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "data_type", "year", "region", "format", "ip_address"], name: "idx_on_date_data_type_year_region_format_ip_address_b56a72723a", unique: true
  end
end
