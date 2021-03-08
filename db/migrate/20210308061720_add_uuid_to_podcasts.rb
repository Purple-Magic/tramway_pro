class AddUuidToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :uuid, :uuid, default: -> { "uuid_generate_v4()" }
  end
end
