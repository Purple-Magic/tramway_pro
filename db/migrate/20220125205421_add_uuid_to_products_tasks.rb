class AddUuidToProductsTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :products_tasks, :uuid, :uuid, default: -> { "uuid_generate_v4()" }
  end
end
