# frozen_string_literal: true

class AddMainImageTramwaySitePeople < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_site_people, :main_image, :text
    add_column :tramway_site_people, :favicon, :text
  end
end
