class CreateBenchkillerUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :benchkiller_users do |t|
      t.integer :bot_telegram_user_id
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
