class AddProjectIdToTramwaySportSchoolDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_documents, :project_id, :integer, default: 1
  end
end
