class CreateChatQuestUlskMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_quest_ulsk_messages do |t|
      t.text :text
      t.text :area
      t.integer :position

      t.timestamps
    end
  end
end
