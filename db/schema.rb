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

ActiveRecord::Schema.define(:version => 20090706012901) do

  create_table "categories", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private"
    t.text     "data"
    t.integer  "location_id"
    t.float    "radius"
    t.integer  "min"
    t.integer  "max"
  end

  add_index "categories", ["id", "type"], :name => "index_categories_on_type_and_id"
  add_index "categories", ["id"], :name => "index_categories_on_id"
  add_index "categories", ["name"], :name => "categories_name_trgm_idx"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "email_addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_addresses", ["id", "type"], :name => "index_email_addresses_on_type_and_id"
  add_index "email_addresses", ["user_id"], :name => "index_email_addresses_on_user_id"

  create_table "eventlets", :force => true do |t|
    t.string   "matcher"
    t.string   "name"
    t.string   "category"
    t.string   "description"
    t.string   "venue"
    t.string   "location"
    t.string   "start"
    t.string   "finish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "eventlets", ["matcher"], :name => "index_eventlets_on_matcher"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "private"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.integer  "activity_id"
    t.text     "venue"
  end

  add_index "events", ["activity_id"], :name => "index_events_on_activity_id"
  add_index "events", ["creator_id"], :name => "index_events_on_creator_id"
  add_index "events", ["location_id"], :name => "index_events_on_location_id"

  create_table "followings", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.boolean  "bidi"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "responded",   :default => false
  end

  add_index "followings", ["bidi", "followee_id", "follower_id"], :name => "index_followings_on_follower_id_and_followee_id_and_bidi"
  add_index "followings", ["followee_id"], :name => "index_followings_on_followee_id"
  add_index "followings", ["follower_id"], :name => "index_followings_on_follower_id"
  add_index "followings", ["responded"], :name => "index_followings_on_responded"

  create_table "hidings", :force => true do |t|
    t.integer  "interest_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hidings", ["interest_id"], :name => "index_hidings_on_interest_id"
  add_index "hidings", ["user_id"], :name => "index_hidings_on_user_id"

  create_table "interestings", :force => true do |t|
    t.integer  "interest_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interestings", ["interest_id"], :name => "index_interestings_on_interest_id"
  add_index "interestings", ["user_id"], :name => "index_interestings_on_user_id"

  create_table "interests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.integer  "time_span_id"
    t.integer  "proximity_id"
    t.integer  "group_size_id"
    t.integer  "familiarity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "interestings_count", :default => 0
  end

  add_index "interests", ["activity_id"], :name => "index_interests_on_activity_id"
  add_index "interests", ["familiarity_id"], :name => "index_interests_on_familiarity_id"
  add_index "interests", ["group_size_id"], :name => "index_interests_on_group_size_id"
  add_index "interests", ["proximity_id"], :name => "index_interests_on_proximity_id"
  add_index "interests", ["time_span_id"], :name => "index_interests_on_time_span_id"
  add_index "interests", ["user_id"], :name => "index_interests_on_user_id"

  create_table "intervals", :force => true do |t|
    t.string   "type"
    t.datetime "start"
    t.datetime "finish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "intervalable_type"
    t.integer  "intervalable_id"
  end

  add_index "intervals", ["finish"], :name => "index_intervals_on_finish"
  add_index "intervals", ["intervalable_id"], :name => "index_intervals_on_intervalable_id"
  add_index "intervals", ["intervalable_type"], :name => "index_intervals_on_intervalable_type"
  add_index "intervals", ["start"], :name => "index_intervals_on_start"
  add_index "intervals", ["type"], :name => "index_intervals_on_type"

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "locationings", :force => true do |t|
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.string   "type"
    t.integer  "radius"
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

  add_index "locations", ["name"], :name => "locations_name_trgm_idx"

  create_table "nevers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nevers", ["activity_id"], :name => "index_nevers_on_activity_id"
  add_index "nevers", ["user_id"], :name => "index_nevers_on_user_id"

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

  create_table "rsvps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", :force => true do |t|
    t.integer  "uploadable_id"
    t.string   "uploadable_type"
    t.integer  "uploaded_by_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "type"
    t.integer  "default_location_id"
    t.integer  "profile_image_id"
    t.string   "time_zone"
    t.integer  "fb_uid"
    t.string   "email_hash"
  end

  add_index "users", ["email_hash"], :name => "index_users_on_email_hash"
  add_index "users", ["fb_uid"], :name => "index_users_on_fb_uid"

end
