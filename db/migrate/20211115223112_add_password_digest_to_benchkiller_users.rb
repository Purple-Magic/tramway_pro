class AddPasswordDigestToBenchkillerUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :benchkiller_users, :password_digest, :text
  end
end
