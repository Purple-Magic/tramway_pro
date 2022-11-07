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

ActiveRecord::Schema.define(version: 20221107195846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "uuid-ossp"

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

  create_table "benchkiller_collations", force: :cascade do |t|
    t.integer "project_id"
    t.text "state"
    t.text "main"
    t.text "words", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "benchkiller_companies", force: :cascade do |t|
    t.text "title"
    t.jsonb "data"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "review_state", default: "unviewed"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.datetime "deleted_at"
    t.text "regions_to_cooperate", array: true
    t.text "regions_to_except", array: true
    t.text "place", array: true
  end

  create_table "benchkiller_companies_users", force: :cascade do |t|
    t.integer "company_id"
    t.integer "user_id"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "benchkiller_deliveries", force: :cascade do |t|
    t.integer "benchkiller_user_id"
    t.text "state"
    t.integer "project_id"
    t.text "text"
    t.string "receivers_ids", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "delivery_state"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.datetime "deleted_at"
  end

  create_table "benchkiller_notifications", force: :cascade do |t|
    t.text "text"
    t.text "send_at"
    t.text "state"
    t.integer "project_id"
    t.text "sending_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "benchkiller_offers", force: :cascade do |t|
    t.integer "message_id"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.text "approval_state"
    t.datetime "deleted_at"
  end

  create_table "benchkiller_offers_tags", force: :cascade do |t|
    t.integer "offer_id"
    t.integer "tag_id"
  end

  create_table "benchkiller_tags", force: :cascade do |t|
    t.text "title"
    t.integer "project_id"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
  end

  create_table "benchkiller_users", force: :cascade do |t|
    t.integer "bot_telegram_user_id"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "password_digest"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.datetime "deleted_at"
  end

  create_table "blogs_links", force: :cascade do |t|
    t.text "url"
    t.datetime "deleted_at"
    t.text "state"
    t.text "image"
    t.text "title"
    t.text "lead"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.text "link_type"
  end

  create_table "bot_telegram_channels", force: :cascade do |t|
    t.integer "bot_id"
    t.text "title"
    t.text "state"
    t.integer "project_id"
    t.text "telegram_channel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "bot_telegram_chats", force: :cascade do |t|
    t.integer "telegram_id"
    t.text "title"
    t.text "chat_type"
    t.jsonb "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "state"
    t.text "telegram_chat_id"
    t.integer "bot_id"
    t.datetime "deleted_at"
  end

  create_table "bot_telegram_messages", force: :cascade do |t|
    t.integer "chat_id"
    t.integer "user_id"
    t.text "text"
    t.jsonb "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "state"
    t.integer "bot_id"
    t.text "message_type", default: "regular"
    t.datetime "deleted_at"
    t.integer "telegram_message_id"
  end

  create_table "bot_telegram_scenario_progress_records", force: :cascade do |t|
    t.integer "bot_telegram_user_id"
    t.integer "bot_telegram_scenario_step_id"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "bot_telegram_scenario_steps", force: :cascade do |t|
    t.text "name"
    t.text "text"
    t.jsonb "reply_markup"
    t.jsonb "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.integer "bot_id"
    t.text "file"
    t.integer "project_id"
    t.integer "delay"
    t.datetime "deleted_at"
  end

  create_table "bot_telegram_users", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "username"
    t.jsonb "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "state"
    t.text "telegram_id"
    t.datetime "deleted_at"
  end

  create_table "bot_telegram_users_states", force: :cascade do |t|
    t.integer "user_id"
    t.integer "bot_id"
    t.text "current_state"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.jsonb "data"
  end

  create_table "bots", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.text "team"
    t.integer "project_id"
    t.text "token"
    t.jsonb "options"
    t.text "slug"
    t.datetime "deleted_at"
  end

  create_table "chat_quest_ulsk_chapters", force: :cascade do |t|
    t.integer "position"
    t.string "quest"
    t.text "state"
    t.integer "project_id"
    t.text "answers"
  end

  create_table "chat_quest_ulsk_games", force: :cascade do |t|
    t.integer "bot_telegram_user_id"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "game_state", default: "started"
    t.integer "current_position"
    t.text "quest"
    t.integer "project_id"
  end

  create_table "chat_quest_ulsk_messages", force: :cascade do |t|
    t.text "text"
    t.integer "position"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "answer"
    t.text "file"
    t.text "quest"
    t.integer "chapter_id"
  end

  create_table "chatquestulsk_games", force: :cascade do |t|
    t.text "area"
    t.integer "bot_telegram_user_id"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "content_stories", force: :cascade do |t|
    t.text "original_file"
    t.text "story"
    t.text "converting_state"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "begin_time"
    t.text "end_time"
    t.datetime "deleted_at"
  end

  create_table "courses", force: :cascade do |t|
    t.text "title"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "team"
    t.datetime "deleted_at"
    t.jsonb "options"
  end

  create_table "courses_comments", force: :cascade do |t|
    t.integer "video_id"
    t.text "begin_time"
    t.text "end_time"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "text"
    t.text "comment_state"
    t.text "file"
    t.text "phrase"
    t.integer "associated_id"
    t.text "associated_type"
    t.datetime "deleted_at"
  end

  create_table "courses_lessons", force: :cascade do |t|
    t.text "title"
    t.integer "topic_id"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.datetime "deleted_at"
  end

  create_table "courses_screencasts", force: :cascade do |t|
    t.integer "project_id"
    t.integer "video_id"
    t.text "scenario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.text "state"
    t.text "begin_time"
    t.text "end_time"
    t.text "file"
    t.text "comment"
  end

  create_table "courses_tasks", force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "position"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.integer "project_id"
    t.text "preparedness_state"
    t.text "max_time"
    t.text "min_time"
    t.datetime "deleted_at"
  end

  create_table "courses_topics", force: :cascade do |t|
    t.text "title"
    t.integer "course_id"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.datetime "deleted_at"
  end

  create_table "courses_videos", force: :cascade do |t|
    t.integer "lesson_id"
    t.text "text"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.text "video_state"
    t.datetime "release_date"
    t.text "duration"
    t.datetime "deleted_at"
    t.text "result_duration"
    t.text "url"
  end

  create_table "elections_candidates", force: :cascade do |t|
    t.text "full_name"
    t.text "description"
    t.integer "area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "consignment"
    t.text "state"
    t.integer "project_id"
  end

  create_table "estimation_coefficients", force: :cascade do |t|
    t.integer "estimation_project_id"
    t.text "state"
    t.float "scale"
    t.integer "project_id"
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.datetime "deleted_at"
    t.text "coefficient_type", default: "price"
  end

  create_table "estimation_costs", force: :cascade do |t|
    t.integer "associated_id"
    t.text "associated_type"
    t.float "price"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "estimation_customers", force: :cascade do |t|
    t.text "title"
    t.text "logo"
    t.text "url"
    t.integer "project_id"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "estimation_expenses", force: :cascade do |t|
    t.integer "estimation_project_id"
    t.integer "project_id"
    t.text "state"
    t.text "title"
    t.float "count"
    t.float "price"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "estimation_projects", force: :cascade do |t|
    t.text "title"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.integer "customer_id"
    t.text "project_state", default: "estimation_in_progress"
    t.text "description"
    t.datetime "deleted_at"
    t.integer "associated_id"
    t.text "associated_type"
    t.integer "default_price"
  end

  create_table "estimation_tasks", force: :cascade do |t|
    t.text "title"
    t.integer "estimation_project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "state"
    t.float "hours"
    t.float "price"
    t.integer "specialists_count", default: 1
    t.text "description"
    t.datetime "deleted_at"
    t.text "task_type", default: "single"
  end

  create_table "find_meds_bases", force: :cascade do |t|
    t.text "name"
    t.text "key"
    t.text "state"
    t.datetime "deleted_at"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "find_meds_feedbacks", force: :cascade do |t|
    t.text "text"
    t.jsonb "data"
    t.text "state"
    t.datetime "deleted_at"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "it_way_certificates", force: :cascade do |t|
    t.integer "event_id"
    t.text "text"
    t.text "certificate_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "it_way_contents", force: :cascade do |t|
    t.text "content_type"
    t.integer "associated_id"
    t.text "associated_type"
    t.datetime "deleted_at"
    t.text "state"
    t.text "title"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "preview"
    t.text "description"
    t.text "url"
  end

  create_table "it_way_participations", force: :cascade do |t|
    t.integer "person_id"
    t.integer "content_id"
    t.text "state"
    t.datetime "deleted_at"
    t.integer "project_id"
    t.text "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content_type"
  end

  create_table "it_way_people", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "avatar"
    t.text "state"
    t.datetime "deleted_at"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "star_id"
    t.integer "telegram_user_id"
    t.integer "event_person_id"
    t.text "twitter_preview"
  end

  create_table "it_way_people_points", force: :cascade do |t|
    t.integer "person_id"
    t.integer "count"
    t.text "comment"
    t.datetime "deleted_at"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "it_way_word_uses", force: :cascade do |t|
    t.integer "word_id"
    t.integer "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.datetime "deleted_at"
  end

  create_table "listai_books", force: :cascade do |t|
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "listai_pages", force: :cascade do |t|
    t.integer "number"
    t.text "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.integer "book_id"
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "magic_wood_actors", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "magic_wood_actors_attendings", force: :cascade do |t|
    t.integer "estimation_project_id"
    t.integer "actor_id"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "magic_wood_actors_photos", force: :cascade do |t|
    t.integer "actor_id"
    t.integer "project_id"
    t.text "state"
    t.text "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "podcast_episodes", force: :cascade do |t|
    t.integer "podcast_id"
    t.text "title"
    t.integer "number"
    t.integer "season"
    t.text "description"
    t.datetime "published_at"
    t.text "image"
    t.text "explicit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.integer "project_id"
    t.uuid "guid"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.text "file"
    t.text "montage_state"
    t.text "file_url"
    t.text "duration"
    t.text "cover"
    t.text "ready_file"
    t.text "premontage_file"
    t.text "trailer"
    t.text "full_video"
    t.text "trailer_video"
    t.datetime "record_time"
    t.text "public_title"
    t.text "montage_process", default: "default"
    t.datetime "deleted_at"
    t.jsonb "render_data"
    t.text "story_cover"
    t.text "story_trailer_video"
    t.datetime "publish_date"
  end

  create_table "podcast_episodes_instances", force: :cascade do |t|
    t.integer "episode_id"
    t.text "state"
    t.integer "project_id"
    t.text "service"
    t.text "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "podcast_episodes_links", force: :cascade do |t|
    t.integer "episode_id"
    t.text "title"
    t.text "link"
    t.integer "project_id"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "podcast_episodes_parts", force: :cascade do |t|
    t.integer "episode_id"
    t.integer "project_id"
    t.datetime "deleted_at"
    t.text "begin_time"
    t.text "end_time"
    t.text "state"
    t.text "preview"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "podcast_episodes_stars", force: :cascade do |t|
    t.integer "episode_id"
    t.integer "star_id"
    t.text "star_type", default: "main"
    t.text "state"
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "podcast_episodes_topics", force: :cascade do |t|
    t.integer "episode_id"
    t.text "title"
    t.text "link"
    t.text "state"
    t.integer "project_id"
    t.text "discus_state"
    t.text "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.datetime "deleted_at"
  end

  create_table "podcast_highlights", force: :cascade do |t|
    t.integer "episode_id"
    t.text "state"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "time"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.text "using_state"
    t.text "cut_begin_time"
    t.text "cut_end_time"
    t.integer "trailer_position"
    t.text "file"
    t.text "ready_file"
    t.text "instagram_story"
    t.datetime "deleted_at"
  end

  create_table "podcast_musics", force: :cascade do |t|
    t.text "file"
    t.text "music_type"
    t.integer "podcast_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "podcast_stars", force: :cascade do |t|
    t.text "nickname"
    t.text "link"
    t.integer "podcast_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "state"
    t.jsonb "profiles"
    t.text "first_name"
    t.text "last_name"
    t.datetime "deleted_at"
  end

  create_table "podcast_stats", force: :cascade do |t|
    t.integer "month"
    t.integer "year"
    t.integer "podcast_id"
    t.text "service"
    t.integer "downloads"
    t.integer "streams"
    t.integer "listeners"
    t.float "hours"
    t.float "average_listenning"
    t.float "overhearing_percent"
    t.datetime "deleted_at"
    t.integer "project_id"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "podcasts", force: :cascade do |t|
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "feed_url"
    t.text "state"
    t.integer "project_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.text "default_image"
    t.text "podcast_type"
    t.text "footer"
    t.text "youtube_footer"
    t.datetime "deleted_at"
    t.text "chat_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "title"
    t.text "state"
    t.datetime "deleted_at"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "tech_name"
    t.text "chat_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.text "product_state", default: "in_progress"
  end

  create_table "products_tasks", force: :cascade do |t|
    t.text "title"
    t.jsonb "data"
    t.text "state"
    t.datetime "deleted_at"
    t.integer "project_id"
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.text "card_id"
    t.text "estimation"
    t.text "description"
  end

  create_table "projects", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state", default: "active"
    t.datetime "deleted_at"
  end

  create_table "purple_magics", force: :cascade do |t|
    t.text "name"
    t.text "public_name"
    t.text "tagline"
    t.text "address"
    t.text "phone"
    t.point "coordinates"
    t.string "state"
    t.string "text"
    t.text "favicon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "main_image"
    t.text "title"
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "red_magics", force: :cascade do |t|
    t.text "name"
    t.text "public_name"
    t.text "tagline"
    t.text "address"
    t.text "phone"
    t.point "coordinates"
    t.text "text"
    t.text "main_image"
    t.text "favicon"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "title"
    t.text "state"
    t.datetime "deleted_at"
  end

  create_table "shortened_urls", id: :serial, force: :cascade do |t|
    t.integer "owner_id"
    t.string "owner_type"
    t.text "url", null: false
    t.string "unique_key", limit: 10, null: false
    t.string "category"
    t.integer "use_count", default: 0, null: false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["category"], name: "index_shortened_urls_on_category"
    t.index ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type"
    t.index ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true
    t.index ["url"], name: "index_shortened_urls_on_url"
  end

  create_table "television_channels", force: :cascade do |t|
    t.text "title"
    t.text "channel_type"
    t.jsonb "rtmp"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.text "broadcast_state"
    t.text "state"
  end

  create_table "television_schedule_items", force: :cascade do |t|
    t.integer "video_id"
    t.text "schedule_type"
    t.jsonb "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "project_id"
    t.integer "channel_id"
    t.text "state"
  end

  create_table "television_videos", force: :cascade do |t|
    t.text "title"
    t.text "file"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.text "remote_file_path"
    t.text "state"
  end

  create_table "time_logs", force: :cascade do |t|
    t.text "associated_type"
    t.integer "associated_id"
    t.text "time_spent"
    t.text "comment"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.integer "user_id"
    t.datetime "deleted_at"
    t.datetime "passed_at"
    t.jsonb "data"
  end

  create_table "tramway_conference_unities", force: :cascade do |t|
    t.text "title"
    t.text "tagline"
    t.text "logo"
    t.text "address"
    t.text "phone"
    t.text "latitude"
    t.text "longtitude"
    t.text "state", default: "active"
    t.text "view_state", default: "hidden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "url"
    t.date "found_date"
    t.text "email"
    t.text "main_image"
    t.text "favicon"
    t.text "name"
    t.text "public_name"
    t.datetime "deleted_at"
  end

  create_table "tramway_devs", force: :cascade do |t|
    t.text "name"
    t.text "public_name"
    t.text "tagline"
    t.text "address"
    t.text "phone"
    t.point "coordinates"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "favicon"
    t.text "main_image"
    t.text "title"
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "tramway_event_actions", force: :cascade do |t|
    t.integer "event_id"
    t.text "title"
    t.datetime "deadline"
    t.text "action_state", default: "must_be_done"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "tramway_event_events", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "photo"
    t.datetime "request_collecting_begin_date"
    t.datetime "request_collecting_end_date"
    t.text "short_description"
    t.text "reach"
    t.datetime "deleted_at"
  end

  create_table "tramway_event_events_places", force: :cascade do |t|
    t.integer "event_id"
    t.integer "place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tramway_event_partakings", force: :cascade do |t|
    t.integer "part_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "position"
    t.text "state"
    t.integer "project_id"
    t.text "part_type", default: "Tramway::Event::Section"
    t.datetime "deleted_at"
  end

  create_table "tramway_event_participant_form_fields", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "field_type", default: "text"
    t.integer "event_id"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.jsonb "options"
    t.integer "position"
    t.datetime "deleted_at"
  end

  create_table "tramway_event_participants", force: :cascade do |t|
    t.integer "event_id"
    t.jsonb "values"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "participation_state", default: "requested"
    t.text "comment"
    t.datetime "deleted_at"
  end

  create_table "tramway_event_people", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "photo"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "description"
    t.datetime "deleted_at"
  end

  create_table "tramway_event_places", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.point "coordinates"
    t.text "photo"
    t.text "city"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "tramway_event_sections", force: :cascade do |t|
    t.integer "event_id"
    t.text "title"
    t.text "description"
    t.text "photo"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "icon"
    t.integer "position"
    t.datetime "deleted_at"
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
    t.integer "project_id"
    t.integer "link_object_id"
    t.text "link_object_type"
    t.jsonb "button"
    t.text "view_name"
    t.jsonb "values"
    t.integer "page_id"
    t.datetime "deleted_at"
  end

  create_table "tramway_landing_forms", force: :cascade do |t|
    t.text "title"
    t.text "form_name"
    t.integer "block_id"
    t.integer "position"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "tramway_landing_tools", force: :cascade do |t|
    t.text "title"
    t.text "account_id"
    t.jsonb "options"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "tramway_news_news", force: :cascade do |t|
    t.text "title"
    t.text "body"
    t.datetime "published_at"
    t.text "photo"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.datetime "deleted_at"
  end

  create_table "tramway_page_pages", force: :cascade do |t|
    t.text "title"
    t.text "body"
    t.text "slug"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.text "view"
    t.text "page_type"
    t.text "view_state", default: "unpublished"
    t.datetime "deleted_at"
  end

  create_table "tramway_partner_organizations", force: :cascade do |t|
    t.text "title"
    t.text "logo"
    t.text "url"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "tramway_partner_partnerships", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "partner_id"
    t.text "partner_type"
    t.text "partnership_type"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "tramway_person_people", force: :cascade do |t|
    t.text "names", array: true
    t.text "short_bio"
    t.text "bio"
    t.text "photo"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tramway_profiles_social_networks", force: :cascade do |t|
    t.text "title"
    t.text "uid"
    t.text "url"
    t.text "record_id"
    t.text "record_type"
    t.text "network_name"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.datetime "deleted_at"
  end

  create_table "tramway_site_people", force: :cascade do |t|
    t.text "names", array: true
    t.text "short_bio"
    t.text "bio"
    t.text "photo"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "main_image"
    t.text "favicon"
    t.text "tagline"
    t.datetime "deleted_at"
  end

  create_table "tramway_sport_school_institutions", force: :cascade do |t|
    t.text "title"
    t.text "tagline"
    t.text "logo"
    t.text "state", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.text "phone"
    t.text "latitude"
    t.text "longtitude"
    t.text "url"
    t.date "found_date"
    t.text "name"
    t.text "main_image"
    t.text "favicon"
    t.text "public_name"
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
    t.integer "project_id"
    t.text "phone"
    t.datetime "deleted_at"
  end

  create_table "videos", force: :cascade do |t|
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "state"
    t.integer "project_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.text "title"
    t.text "preview"
    t.text "description"
    t.datetime "deleted_at"
  end

  create_table "webhooks", force: :cascade do |t|
    t.text "state"
    t.datetime "deleted_at"
    t.text "service"
    t.jsonb "params"
    t.jsonb "headers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "words", force: :cascade do |t|
    t.text "main"
    t.text "synonims", array: true
    t.text "description"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.text "review_state", default: "approved"
    t.datetime "deleted_at"
  end

  create_table "youtube_accounts", force: :cascade do |t|
    t.text "authorization_code"
    t.text "state"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "access_token"
  end

end
