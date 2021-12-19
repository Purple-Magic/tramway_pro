class AddDeletedAtToAllModels < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_profiles_social_networks, :deleted_at, :datetime
    add_column :tramway_user_users, :deleted_at, :datetime
    add_column :tramway_conference_unities, :deleted_at, :datetime
    add_column :tramway_partner_partnerships, :deleted_at, :datetime
    add_column :tramway_event_events, :deleted_at, :datetime
    add_column :tramway_event_participant_form_fields, :deleted_at, :datetime
    add_column :tramway_event_participants, :deleted_at, :datetime
    add_column :tramway_event_sections, :deleted_at, :datetime
    add_column :tramway_event_people, :deleted_at, :datetime
    add_column :tramway_event_partakings, :deleted_at, :datetime
    add_column :tramway_event_places, :deleted_at, :datetime
    add_column :tramway_event_actions, :deleted_at, :datetime
    add_column :tramway_news_news, :deleted_at, :datetime
    add_column :tramway_page_pages, :deleted_at, :datetime
    add_column :words, :deleted_at, :datetime
    add_column :it_way_certificates, :deleted_at, :datetime
    add_column :tramway_landing_tools, :deleted_at, :datetime
    add_column :tramway_landing_blocks, :deleted_at, :datetime
    add_column :tramway_partner_organizations, :deleted_at, :datetime
    add_column :tramway_site_people, :deleted_at, :datetime
    add_column :listai_books, :deleted_at, :datetime
    add_column :listai_pages, :deleted_at, :datetime
    add_column :podcasts, :deleted_at, :datetime
    add_column :podcast_episodes, :deleted_at, :datetime
    add_column :red_magics, :deleted_at, :datetime
    add_column :courses, :deleted_at, :datetime
    add_column :courses_topics, :deleted_at, :datetime
    add_column :courses_lessons, :deleted_at, :datetime
    add_column :courses_videos, :deleted_at, :datetime
    add_column :courses_comments, :deleted_at, :datetime
    add_column :courses_tasks, :deleted_at, :datetime
    add_column :time_logs, :deleted_at, :datetime
    add_column :purple_magics, :deleted_at, :datetime
    add_column :bot_telegram_users, :deleted_at, :datetime
    add_column :bot_telegram_messages, :deleted_at, :datetime
    add_column :bot_telegram_scenario_steps, :deleted_at, :datetime
    add_column :bot_telegram_scenario_progress_records, :deleted_at, :datetime
    add_column :bots, :deleted_at, :datetime
    add_column :estimation_projects, :deleted_at, :datetime
    add_column :estimation_tasks, :deleted_at, :datetime
    add_column :estimation_customers, :deleted_at, :datetime
    add_column :estimation_coefficients, :deleted_at, :datetime
    add_column :benchkiller_users, :deleted_at, :datetime
    add_column :benchkiller_companies, :deleted_at, :datetime
    add_column :benchkiller_notifications, :deleted_at, :datetime
    add_column :benchkiller_offers, :deleted_at, :datetime
    add_column :benchkiller_tags, :deleted_at, :datetime
    add_column :benchkiller_collations, :deleted_at, :datetime
    add_column :estimation_expenses, :deleted_at, :datetime
    add_column :estimation_costs, :deleted_at, :datetime
    add_column :podcast_episodes_topics, :deleted_at, :datetime
    add_column :podcast_episodes_links, :deleted_at, :datetime
    add_column :podcast_episodes_instances, :deleted_at, :datetime
    add_column :podcast_episodes_stars, :deleted_at, :datetime
    add_column :podcast_highlights, :deleted_at, :datetime
    add_column :podcast_musics, :deleted_at, :datetime
    add_column :podcast_stars, :deleted_at, :datetime
    add_column :content_stories, :deleted_at, :datetime
    add_column :magic_wood_actors, :deleted_at, :datetime
    add_column :magic_wood_actors_photos, :deleted_at, :datetime
    add_column :magic_wood_actors_attendings, :deleted_at, :datetime
    add_column :videos, :deleted_at, :datetime
    add_column :projects, :deleted_at, :datetime
    add_column :tramway_devs, :deleted_at, :datetime
  end
end
