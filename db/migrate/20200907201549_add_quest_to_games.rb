class AddQuestToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :chat_quest_ulsk_games, :quest, :text
    remove_column :chat_quest_ulsk_games, :area
  end
end
