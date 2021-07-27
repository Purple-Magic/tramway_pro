class CreateTimeLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :time_logs do |t|
      t.text :associated_type
      t.integer :associated_id
      t.text :time_spent
      t.text :comment
      t.integer :project_id

      t.timestamps
    end
  end
end
