# frozen_string_literal: true

class AddPageTypeToTramwayPagePages < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_page_pages, :page_type, :text
  end
end
