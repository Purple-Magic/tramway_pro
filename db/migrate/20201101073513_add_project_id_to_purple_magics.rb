class AddProjectIdToPurpleMagics < ActiveRecord::Migration[5.1]
  def change
    add_column :purple_magics, :project_id, :integer
  end
end
