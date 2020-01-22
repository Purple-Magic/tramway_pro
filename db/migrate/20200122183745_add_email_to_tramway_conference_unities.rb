# frozen_string_literal: true

class AddEmailToTramwayConferenceUnities < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_conference_unities, :email, :text
  end
end
