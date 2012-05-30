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

ActiveRecord::Schema.define(:version => 20120530071444) do

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.text     "body",             :limit => 255
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "ip"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "commentable_index"

  create_table "posts", :force => true do |t|
    t.text     "content"
    t.integer  "likes",              :default => 0
    t.integer  "dislikes",           :default => 0
    t.boolean  "approved",           :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "ip"
    t.boolean  "admin",              :default => false
    t.string   "type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "reviewed",           :default => false
  end

  create_table "questions", :force => true do |t|
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
