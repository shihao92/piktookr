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

ActiveRecord::Schema.define(version: 20160728063327) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "okr_roles", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "okr_teams", force: :cascade do |t|
    t.string   "name",        default: "", null: false
    t.string   "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "okr_user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "okr_role_id"
    t.index ["okr_role_id"], name: "index_okr_user_roles_on_okr_role_id", using: :btree
    t.index ["user_id"], name: "index_okr_user_roles_on_user_id", using: :btree
  end

  create_table "okr_user_teams", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "okr_team_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["okr_team_id"], name: "index_okr_user_teams_on_okr_team_id", using: :btree
    t.index ["user_id"], name: "index_okr_user_teams_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "status"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
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
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "name"
    t.string   "status"
    t.integer  "teams_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["teams_id"], name: "index_users_on_teams_id", using: :btree
  end

  add_foreign_key "okr_user_roles", "okr_roles"
  add_foreign_key "okr_user_roles", "users"
  add_foreign_key "okr_user_teams", "okr_teams"
  add_foreign_key "okr_user_teams", "users"
  add_foreign_key "users", "teams", column: "teams_id"
end
