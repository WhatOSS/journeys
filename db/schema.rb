# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140525153142) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "journey_id"
    t.text     "slug"
    t.integer  "user_id"
  end

  add_index "events", ["journey_id"], name: "index_events_on_journey_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "journeys", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "journeys", ["user_id"], name: "index_journeys_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["ip"], name: "index_users_on_ip", unique: true, using: :btree

end
