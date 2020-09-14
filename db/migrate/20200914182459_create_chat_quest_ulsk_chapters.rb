class CreateChatQuestUlskChapters < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_quest_ulsk_chapters do |t|
      t.integer :position
      t.string :quest
      t.text :state
    end
  end
end
