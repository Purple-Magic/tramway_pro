class AddStateToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :state, :text, default: :active
  end
end
