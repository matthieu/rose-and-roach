# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 8) do

  create_table "actions", :force => true do |t|
    t.string  "name",                       :null => false
    t.integer "project_id",                 :null => false
    t.integer "classifier",  :default => 0, :null => false
    t.integer "saving_type"
    t.text    "desc"
    t.integer "unit"
    t.float   "quantity"
  end

  add_index "actions", ["classifier"], :name => "index_actions_on_classifier"
  add_index "actions", ["project_id"], :name => "index_actions_on_project_id"

  create_table "needs", :force => true do |t|
    t.integer "need_type",                 :null => false
    t.string  "desc",       :limit => 200
    t.boolean "local",                     :null => false
    t.integer "project_id",                :null => false
  end

  add_index "needs", ["project_id"], :name => "index_needs_on_project_id"

  create_table "participations", :force => true do |t|
    t.integer "part_type",                                :null => false
    t.decimal "quantity",  :precision => 14, :scale => 2
    t.integer "user_id",                                  :null => false
    t.integer "need_id",                                  :null => false
  end

  add_index "participations", ["user_id"], :name => "index_participations_on_user_id"
  add_index "participations", ["need_id"], :name => "index_participations_on_need_id"

  create_table "pledges", :force => true do |t|
    t.integer "user_id",                  :null => false
    t.integer "action_id",                :null => false
    t.integer "status",    :default => 0, :null => false
  end

  add_index "pledges", ["user_id"], :name => "index_pledges_on_user_id"
  add_index "pledges", ["action_id"], :name => "index_pledges_on_action_id"
  add_index "pledges", ["status"], :name => "index_pledges_on_status"

  create_table "projects", :force => true do |t|
    t.string "name",       :limit => 100, :null => false
    t.text   "desc"
    t.string "short_desc", :limit => 200
  end

  create_table "savings", :force => true do |t|
    t.integer "saving_type",                :null => false
    t.string  "desc",        :limit => 200
    t.integer "unit"
    t.float   "quantity"
    t.integer "project_id",                 :null => false
  end

  add_index "savings", ["project_id"], :name => "index_savings_on_project_id"

  create_table "users", :force => true do |t|
    t.string   "login",       :limit => 20
    t.string   "password",    :limit => 50
    t.integer  "role"
    t.string   "e_mail",      :limit => 100
    t.string   "firstname",   :limit => 100
    t.string   "lastname",    :limit => 100
    t.string   "cookie_hash", :limit => 60
    t.datetime "created_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login"

  create_table "users_projects", :id => false, :force => true do |t|
    t.integer "project_id", :null => false
    t.integer "user_id",    :null => false
  end

  add_index "users_projects", ["project_id", "user_id"], :name => "index_users_projects_on_project_id_and_user_id"
  add_index "users_projects", ["user_id"], :name => "index_users_projects_on_user_id"

end
