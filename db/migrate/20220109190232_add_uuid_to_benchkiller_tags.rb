class AddUuidToBenchkillerTags < ActiveRecord::Migration[5.1]
  def change
    add_column :benchkiller_tags, :uuid, :uuid, default: -> { "uuid_generate_v4()" }
  end
end
