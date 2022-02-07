class AddChatIdToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :chat_id, :text
  end
end
