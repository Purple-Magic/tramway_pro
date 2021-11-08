class CreateBenchkillerNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :benchkiller_notifications do |t|
      t.text :text
      t.text :send_at
      t.text :state
      t.integer :project_id
      t.text :sending_state

      t.timestamps
    end
  end
end
