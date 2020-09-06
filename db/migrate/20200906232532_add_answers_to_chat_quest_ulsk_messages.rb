class AddAnswersToChatQuestUlskMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :chat_quest_ulsk_messages, :answer, :text
  end
end
