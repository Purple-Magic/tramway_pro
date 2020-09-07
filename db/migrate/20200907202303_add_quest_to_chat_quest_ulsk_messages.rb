class AddQuestToChatQuestUlskMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :chat_quest_ulsk_messages, :quest, :text
    remove_column :chat_quest_ulsk_messages, :area
  end
end
