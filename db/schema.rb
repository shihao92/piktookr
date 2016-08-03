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

ActiveRecord::Schema.define(version: 20160803083701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "company_key_results", force: :cascade do |t|
    t.string   "key_result"
    t.decimal  "progress",             precision: 5, scale: 2
    t.integer  "company_objective_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["company_objective_id"], name: "index_company_key_results_on_company_objective_id", using: :btree
  end

  create_table "company_objectives", force: :cascade do |t|
    t.string   "objective"
    t.decimal  "progress",         precision: 5, scale: 2
    t.integer  "timeframe_log_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["timeframe_log_id"], name: "index_company_objectives_on_timeframe_log_id", using: :btree
  end

  create_table "contributions", force: :cascade do |t|
    t.string   "contribution_comment"
    t.integer  "personal_key_result_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["personal_key_result_id"], name: "index_contributions_on_personal_key_result_id", using: :btree
  end

  create_table "okr_company_teams", force: :cascade do |t|
    t.integer  "company_key_result_id"
    t.integer  "team_objective_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["company_key_result_id"], name: "index_okr_company_teams_on_company_key_result_id", using: :btree
    t.index ["team_objective_id"], name: "index_okr_company_teams_on_team_objective_id", using: :btree
  end

  create_table "okr_roles", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "okr_team_personals", force: :cascade do |t|
    t.integer  "team_key_result_id"
    t.integer  "personal_objective_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["personal_objective_id"], name: "index_okr_team_personals_on_personal_objective_id", using: :btree
    t.index ["team_key_result_id"], name: "index_okr_team_personals_on_team_key_result_id", using: :btree
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

  create_table "personal_key_results", force: :cascade do |t|
    t.string   "key_result"
    t.decimal  "progress",              precision: 5, scale: 2
    t.integer  "personal_objective_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["personal_objective_id"], name: "index_personal_key_results_on_personal_objective_id", using: :btree
  end

  create_table "personal_objectives", force: :cascade do |t|
    t.string   "objective"
    t.decimal  "progress",         precision: 5, scale: 2
    t.integer  "timeframe_log_id"
    t.integer  "user_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["timeframe_log_id"], name: "index_personal_objectives_on_timeframe_log_id", using: :btree
    t.index ["user_id"], name: "index_personal_objectives_on_user_id", using: :btree
  end

  create_table "team_key_results", force: :cascade do |t|
    t.string   "key_result"
    t.decimal  "progress",          precision: 5, scale: 2
    t.integer  "team_objective_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["team_objective_id"], name: "index_team_key_results_on_team_objective_id", using: :btree
  end

  create_table "team_objectives", force: :cascade do |t|
    t.string   "objective"
    t.decimal  "progress",         precision: 5, scale: 2
    t.integer  "timeframe_log_id"
    t.integer  "okr_team_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["okr_team_id"], name: "index_team_objectives_on_okr_team_id", using: :btree
    t.index ["timeframe_log_id"], name: "index_team_objectives_on_timeframe_log_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "status"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "timeframe_logs", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "timeframe_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "quarter"
    t.index ["timeframe_id"], name: "index_timeframe_logs_on_timeframe_id", using: :btree
  end

  create_table "timeframes", force: :cascade do |t|
    t.integer  "year"
    t.string   "timeframe_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
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

  add_foreign_key "company_key_results", "company_objectives"
  add_foreign_key "company_objectives", "timeframe_logs"
  add_foreign_key "contributions", "personal_key_results"
  add_foreign_key "okr_company_teams", "company_key_results"
  add_foreign_key "okr_company_teams", "team_objectives"
  add_foreign_key "okr_team_personals", "personal_objectives"
  add_foreign_key "okr_team_personals", "team_key_results"
  add_foreign_key "okr_user_roles", "okr_roles"
  add_foreign_key "okr_user_roles", "users"
  add_foreign_key "okr_user_teams", "okr_teams"
  add_foreign_key "okr_user_teams", "users"
  add_foreign_key "personal_key_results", "personal_objectives"
  add_foreign_key "personal_objectives", "timeframe_logs"
  add_foreign_key "personal_objectives", "users"
  add_foreign_key "team_key_results", "team_objectives"
  add_foreign_key "team_objectives", "okr_teams"
  add_foreign_key "team_objectives", "timeframe_logs"
  add_foreign_key "timeframe_logs", "timeframes"
  add_foreign_key "users", "teams", column: "teams_id"
end
