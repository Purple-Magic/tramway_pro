class AddTelegramUserIdToItWayPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_people, :telegram_user_id, :integer
  end
end
