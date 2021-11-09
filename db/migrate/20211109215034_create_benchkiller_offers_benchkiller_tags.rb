class CreateBenchkillerOffersBenchkillerTags < ActiveRecord::Migration[5.1]
  def change
    create_table :benchkiller_offers_tags do |t|
      t.integer :offer_id
      t.integer :tag_id
    end
  end
end
