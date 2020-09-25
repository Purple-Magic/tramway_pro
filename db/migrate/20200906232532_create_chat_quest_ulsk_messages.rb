class CreateChatQuestUlskMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_quest_ulsk_messages do |t|
      t.text "text"
      t.integer "position"
      t.text "state"
      t.integer "project_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.text "answer"
      t.text "file"
      t.text "quest"
      t.integer "chapter_id"
      t.text :answer

      t.timestamps
    end
  end
end
