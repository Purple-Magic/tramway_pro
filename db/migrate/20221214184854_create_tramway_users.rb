class CreateTramwayUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_users do |t|
      t.text :email
      t.text :password_digest
      t.text :first_name
      t.text :last_name
      t.text :patronymic
      t.text :avatar
      t.text :state
      t.text :role
      t.integer :project_id
      t.text :phone
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
