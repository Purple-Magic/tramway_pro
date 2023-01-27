class AddOptionsToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :options, :jsonb
  end
end
