class AddProjectIdToListaiBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :listai_books, :project_id, :integer
  end
end
