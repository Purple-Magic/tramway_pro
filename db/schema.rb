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

ActiveRecord::Schema.define(version: 20180211132840) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "tramway_landing_blocks", force: :cascade do |t|
    t.text "title"
    t.text "background"
    t.text "block_type"
    t.integer "position"
    t.text "state", default: "active"
    t.text "view_state", default: "hidden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "navbar_link", default: "not_exist"
    t.text "anchor"
    t.text "description"
  end

  create_table "tramway_sport_school_documents", force: :cascade do |t|
    t.text "title"
    t.text "file"
    t.text "state", default: "active"
    t.text "view_state", default: "hidden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tramway_sport_school_institutions", force: :cascade do |t|
    t.text "title"
    t.text "tagline"
    t.text "logo"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tramway_sport_school_kind_sports", force: :cascade do |t|
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state", default: "active"
    t.text "view_state", default: "hidden"
    t.text "image"
    t.text "description"
  end

  create_table "tramway_sport_school_organizations", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "logo"
    t.text "organization_type", default: "required"
    t.text "link"
    t.text "state", default: "active"
    t.text "view_state", default: "hidden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tramway_sport_school_trainers", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "patronymic"
    t.text "state", default: "active"
    t.text "view_state", default: "hidden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "degree"
    t.text "photo"
    t.text "description"
  end

  create_table "tramway_user_users", force: :cascade do |t|
    t.text "email"
    t.text "password_digest"
    t.text "first_name"
    t.text "last_name"
    t.text "patronymic"
    t.text "avatar"
    t.text "state"
    t.text "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
