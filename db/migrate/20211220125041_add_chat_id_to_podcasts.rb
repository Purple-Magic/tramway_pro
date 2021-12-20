class AddChatIdToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :chat_id, :text
  end
end
