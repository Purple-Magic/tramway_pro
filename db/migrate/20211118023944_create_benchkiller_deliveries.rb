class CreateBenchkillerDeliveries < ActiveRecord::Migration[5.1]
  def change
    create_table :benchkiller_deliveries do |t|
      t.integer :benchkiller_user_id
      t.text :state
      t.integer :project_id
      t.text :text
      t.string :receivers_ids, array: true

      t.timestamps
    end
  end
end
