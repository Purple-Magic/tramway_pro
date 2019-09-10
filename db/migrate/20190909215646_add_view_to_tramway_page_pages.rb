class AddViewToTramwayPagePages < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_page_pages, :view, :text
  end
end
