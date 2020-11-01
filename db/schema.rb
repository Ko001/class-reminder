# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_01_110501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_infos", force: :cascade do |t|
    t.string "course"
    t.string "prof"
    t.text "location"
    t.string "pass"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "day"
    t.integer "time"
  end

  create_table "course_times", force: :cascade do |t|
    t.integer "class_num"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "start_hour"
    t.integer "start_minute"
    t.integer "end_hour"
    t.integer "end_minute"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "university"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
