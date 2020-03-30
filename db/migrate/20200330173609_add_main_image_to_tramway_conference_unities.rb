# frozen_string_literal: true

class AddMainImageToTramwayConferenceUnities < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_conference_unities, :main_image, :text
  end
end
