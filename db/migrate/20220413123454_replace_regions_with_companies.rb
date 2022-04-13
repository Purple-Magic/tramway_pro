class ReplaceRegionsWithCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :benchkiller_companies, :regions_to_cooperate, :text, array: true
    add_column :benchkiller_companies, :regions_to_except, :text, array: true
    add_column :benchkiller_companies, :place, :text, array: true
  end
end
