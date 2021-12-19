class AddMoreDeletedAt < ActiveRecord::Migration[5.1]
  def change
    add_column :benchkiller_companies_users, :deleted_at, :datetime
    add_column :benchkiller_deliveries, :deleted_at, :datetime
    add_column :bot_telegram_channels, :deleted_at, :datetime
    add_column :bot_telegram_chats, :deleted_at, :datetime
    add_column :bot_telegram_users_states, :deleted_at, :datetime
    add_column :it_way_word_uses, :deleted_at, :datetime

    #drop_table :elections_candidates
  end
end
