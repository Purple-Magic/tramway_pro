class AddCurrentPositionToChatQuestUlskGames < ActiveRecord::Migration[5.1]
  def change
    add_column :chat_quest_ulsk_games, :current_position, :integer
  end
end
