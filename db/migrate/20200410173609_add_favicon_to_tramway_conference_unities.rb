# frozen_string_literal: true

class AddFaviconToTramwayConferenceUnities < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_conference_unities, :favicon, :text
  end
end
