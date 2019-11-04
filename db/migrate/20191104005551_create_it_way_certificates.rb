class CreateItWayCertificates < ActiveRecord::Migration[5.1]
  def change
    create_table :it_way_certificates do |t|
      t.integer :event_id
      t.text :text
      t.text :certificate_type

      t.timestamps
    end
  end
end
