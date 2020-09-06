class CreateChatQuestUlskMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_quest_ulsk_messages do |t|
      t.text :area
      t.text :text
      t.integer :position
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
