# frozen_string_literal: true

class AddFaviconToTramwaySportSchoolInstitutions < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_institutions, :favicon, :text
  end
end
