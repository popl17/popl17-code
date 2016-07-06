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

ActiveRecord::Schema.define(version: 20160629192900) do

  create_table "belongs_to_departments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "belongs_to_users", force: true do |t|
    t.integer  "belongs_to_department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "belongs_to_users", ["belongs_to_department_id"], name: "index_belongs_to_users_on_belongs_to_department_id", using: :btree

  create_table "dbfk_departments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dbfk_users", force: true do |t|
    t.integer  "dbfk_department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dbfk_users", ["dbfk_department_id"], name: "index_dbfk_users_on_dbfk_department_id", using: :btree

  create_table "indexed_key_values", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "indexed_key_values", ["key"], name: "index_indexed_key_values_on_key", unique: true, using: :btree

  create_table "m_counters", force: true do |t|
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "microposts", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "simple_departments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_key_values", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_users", force: true do |t|
    t.integer  "simple_department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unique_key_values", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
