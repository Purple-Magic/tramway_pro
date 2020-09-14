class AddProjectIdToChatQuestUlskChapters < ActiveRecord::Migration[5.1]
  def change
    add_column :chat_quest_ulsk_chapters, :project_id, :integer
  end
end
