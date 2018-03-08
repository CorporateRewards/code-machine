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

ActiveRecord::Schema.define(version: 20180308193009) do

  create_table "code_submissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code_entered"
    t.integer  "user_id"
    t.string   "user_email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "code_id"
    t.index ["code_id"], name: "index_code_submissions_on_code_id", using: :btree
  end

  create_table "codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code"
    t.string   "property"
    t.string   "reference"
    t.string   "post_as"
    t.string   "arrival_date"
    t.string   "status"
    t.string   "booking_type"
    t.string   "booked_date"
    t.string   "booking_user_email"
    t.string   "number_of_tickets"
    t.string   "user_group"
    t.datetime "date_claimed"
    t.datetime "date_sent"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "booking_email"
    t.string   "agency_email"
  end

  create_table "mr_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "cr_id"
    t.string   "name"
    t.string   "email"
    t.string   "user_group"
    t.string   "company"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "code_submissions", "codes"
end
