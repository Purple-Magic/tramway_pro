class AddGameStateToChatQuestUlskGames < ActiveRecord::Migration[5.1]
  def change
    add_column :chat_quest_ulsk_games, :game_state, :text, default: :started
  end
end
