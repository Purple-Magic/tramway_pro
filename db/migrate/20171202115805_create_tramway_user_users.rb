# FIXME specify rails version
# default is 5.1
class CreateTramwayUserUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_user_users do |t|
      t.text :email
      t.text :password_digest
      t.text :first_name
      t.text :last_name
      t.text :patronymic
      t.text :avatar
      t.text :state
      t.text :role

      t.timestamps null: false
    end
  end
end
