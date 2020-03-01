class AddPhoneToTramwayUserUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_user_users, :phone, :text
  end
end
