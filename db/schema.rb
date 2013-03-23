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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130317083510) do

  create_table "follows", :force => true do |t|
    t.integer  "following_user_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "follows", ["following_user_id"], :name => "index_follows_on_following_user_id"
  add_index "follows", ["user_id"], :name => "index_follows_on_user_id"

  create_table "notes", :force => true do |t|
    t.integer  "pagenum"
    t.integer  "slide_id"
    t.integer  "user_id"
    t.integer  "top"
    t.integer  "left"
    t.integer  "width"
    t.integer  "height"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "notes", ["pagenum"], :name => "index_notes_on_pagenum"
  add_index "notes", ["slide_id"], :name => "index_notes_on_slide_id"
  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"

  create_table "slides", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pages"
    t.string   "s3_key"
    t.string   "filename"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.text     "name"
    t.text     "description"
    t.integer  "view_count",  :default => 0
    t.string   "slug"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "image_url"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.text     "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
