class RemoveStateFromTramwayEventEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column "benchkiller_collations", :state

    remove_column "benchkiller_companies", :state

    remove_column "benchkiller_companies_users", :state

    remove_column "benchkiller_deliveries", :state

    remove_column "benchkiller_notifications", :state

    remove_column "benchkiller_offers", :state

    remove_column "benchkiller_tags", :state

    remove_column "benchkiller_users", :state

    remove_column "blogs_links", :state

    remove_column "bot_telegram_channels", :state

    remove_column "bot_telegram_chats", :state

    remove_column "bot_telegram_messages", :state

    remove_column "bot_telegram_scenario_progress_records", :state

    remove_column "bot_telegram_scenario_steps", :state

    remove_column "bot_telegram_users", :state

    remove_column "bot_telegram_users_states", :state

    remove_column "bots", :state

    remove_column "chat_quest_ulsk_chapters", :state

    remove_column "chat_quest_ulsk_games", :state

    remove_column "chat_quest_ulsk_messages", :state

    remove_column "content_stories", :state

    remove_column "courses", :state

    remove_column "courses_comments", :state

    remove_column "courses_lessons", :state

    remove_column "courses_screencasts", :state

    remove_column "courses_tasks", :state

    remove_column "courses_topics", :state

    remove_column "courses_videos", :state

    remove_column "estimation_coefficients", :state

    remove_column "estimation_costs", :state

    remove_column "estimation_customers", :state

    remove_column "estimation_expenses", :state

    remove_column "estimation_projects", :state

    remove_column "estimation_tasks", :state

    remove_column "find_meds_bases", :state

    remove_column "find_meds_feedbacks", :state

    remove_column "it_way_certificates", :state

    remove_column "it_way_contents", :state

    remove_column "it_way_participations", :state

    remove_column "it_way_people", :state

    remove_column "it_way_people_points", :state

    remove_column "it_way_word_uses", :state

    remove_column "listai_books", :state

    remove_column "listai_pages", :state

    remove_column "magic_wood_actors", :state


    remove_column "magic_wood_actors_photos", :state

    remove_column "podcast_episodes", :state

    remove_column "podcast_episodes_instances", :state

    remove_column "podcast_episodes_links", :state

    remove_column "podcast_episodes_parts", :state

    remove_column "podcast_episodes_stars", :state

    remove_column "podcast_episodes_topics", :state

    remove_column "podcast_highlights", :state

    remove_column "podcast_musics", :state

    remove_column "podcast_stars", :state

    remove_column "podcast_stats", :state

    remove_column "podcasts", :state

    remove_column "products", :state

    remove_column "products_tasks", :state

    remove_column "projects", :state

    remove_column "purple_magics", :state

    remove_column "red_magics", :state

    remove_column "television_channels", :state

    remove_column "television_schedule_items", :state

    remove_column "television_videos", :state

    remove_column "time_logs", :state

    remove_column "tramway_conference_unities", :state

    remove_column "tramway_devs", :state

    remove_column "tramway_event_actions", :state

    remove_column "tramway_event_events", :state

    remove_column "tramway_event_partakings", :state

    remove_column "tramway_event_participant_form_fields", :state

    remove_column "tramway_event_participants", :state

    remove_column "tramway_event_people", :state

    remove_column "tramway_event_places", :state

    remove_column "tramway_event_sections", :state

    remove_column "tramway_landing_blocks", :state

    remove_column "tramway_landing_forms", :state

    remove_column "tramway_landing_tools", :state

    remove_column "tramway_news_news", :state

    remove_column "tramway_page_pages", :state

    remove_column "tramway_partner_organizations", :state

    remove_column "tramway_partner_partnerships", :state

    remove_column "tramway_person_people", :state

    remove_column "tramway_profiles_social_networks", :state

    remove_column "tramway_site_people", :state

    remove_column "tramway_sport_school_institutions", :state

    remove_column "tramway_user_users", :state

    remove_column "tramway_users", :state

    remove_column "videos", :state

    remove_column "webhooks", :state

    remove_column "words", :state

    remove_column "youtube_accounts", :state
  end
end
