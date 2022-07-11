class CreateYoutubeAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :youtube_accounts do |t|
      t.text :authorization_code
      t.text :state
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
