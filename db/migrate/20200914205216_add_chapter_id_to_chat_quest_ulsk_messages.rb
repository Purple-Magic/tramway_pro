class AddChapterIdToChatQuestUlskMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :chat_quest_ulsk_messages, :chapter_id, :integer
  end
end
