# frozen_string_literal: true

class AddMainImageToTramwaySportSchoolInstitutions < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_institutions, :main_image, :text
  end
end
