class CreateBenchkillerOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :benchkiller_offers do |t|
      t.integer :message_id
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
