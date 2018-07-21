class AddDocumentTypeToTramwaySportSchoolDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_documents, :document_type, :text
  end
end
