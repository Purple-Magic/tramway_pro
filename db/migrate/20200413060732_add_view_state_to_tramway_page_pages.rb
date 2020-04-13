# frozen_string_literal: true

class AddViewStateToTramwayPagePages < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_page_pages, :view_state, :text, default: :unpublished
  end
end
