class AddAccessTokenToYoutubeAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :youtube_accounts, :access_token, :text
  end
end
