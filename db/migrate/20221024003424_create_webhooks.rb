class CreateWebhooks < ActiveRecord::Migration[5.1]
  def change
    create_table :webhooks do |t|
      t.text :state
      t.datetime :deleted_at
      t.text :service
      t.jsonb :params
      t.jsonb :headers

      t.timestamps
    end
  end
end
