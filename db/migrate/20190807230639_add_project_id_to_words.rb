class AddProjectIdToWords < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :project_id, :integer
  end
end
