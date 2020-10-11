class AddStatesToNewModels < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :state, :text
    add_column :episodes, :state, :text
  end
end
