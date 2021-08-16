class AddUuidToPodcastEpisodesTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes_topics, :uuid, :uuid, default: -> { "uuid_generate_v4()" }
  end
end
