# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090624015301) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followings", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.boolean  "bidi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followings", ["followee_id"], :name => "index_followings_on_followee_id"
  add_index "followings", ["follower_id"], :name => "index_followings_on_follower_id"

  create_table "intervals", :force => true do |t|
    t.string   "type"
    t.datetime "start"
    t.datetime "finish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "intervalable_type"
    t.integer  "intervalable_id"
  end

  add_index "intervals", ["intervalable_id"], :name => "index_intervals_on_intervalable_id"
  add_index "intervals", ["intervalable_type"], :name => "index_intervals_on_intervalable_type"
  add_index "intervals", ["type"], :name => "index_intervals_on_type"

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locationings", :force => true do |t|
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.string   "type"
  end

  add_index "locationings", ["locatable_id"], :name => "index_locationings_on_locatable_id"
  add_index "locationings", ["locatable_type"], :name => "index_locationings_on_locatable_type"
  add_index "locationings", ["location_id"], :name => "index_locationings_on_location_id"
  add_index "locationings", ["type"], :name => "index_locationings_on_type"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.float    "radius"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string   "type"
    t.text     "url"
    t.text     "data"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources", ["type"], :name => "index_resources_on_type"
  add_index "resources", ["user_id"], :name => "index_resources_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "type"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
