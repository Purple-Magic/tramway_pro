class AddUuidToWords < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'uuid-ossp'
    add_column :words, :uuid, :uuid, default: 'uuid_generate_v4()'
  end
end
