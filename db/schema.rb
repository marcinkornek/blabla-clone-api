# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160817054009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cars", force: :cascade do |t|
    t.string   "brand"
    t.string   "model"
    t.string   "production_year"
    t.integer  "comfort"
    t.integer  "places"
    t.integer  "color"
    t.integer  "category"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "car_photo"
  end

  create_table "ride_requests", force: :cascade do |t|
    t.integer  "passenger_id"
    t.integer  "ride_id"
    t.integer  "status",       default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "places"
  end

  create_table "rides", force: :cascade do |t|
    t.string   "start_city"
    t.string   "start_city_lat"
    t.string   "start_city_lng"
    t.string   "destination_city"
    t.string   "destination_city_lat"
    t.string   "destination_city_lng"
    t.integer  "driver_id"
    t.integer  "places"
    t.datetime "start_date"
    t.decimal  "price"
    t.integer  "car_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "currency"
    t.integer  "taken_places",         default: 0
    t.integer  "requested_places",     default: 0
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "uid"
    t.string   "provider"
    t.string   "tel_num"
    t.string   "birth_year"
    t.integer  "role",                   default: 0
    t.string   "avatar"
    t.datetime "last_seen_at"
    t.integer  "gender"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
