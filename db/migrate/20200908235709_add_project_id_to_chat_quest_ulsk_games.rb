class AddProjectIdToChatQuestUlskGames < ActiveRecord::Migration[5.1]
  def change
    add_column :chat_quest_ulsk_games, :project_id, :integer
  end
end
