class AddStateToChatQuestUlskMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :chat_quest_ulsk_messages, :state, :text
  end
end
