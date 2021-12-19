class AddDeletedAtToTramwayLandingForms < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_landing_forms, :deleted_at, :datetime
  end
end
