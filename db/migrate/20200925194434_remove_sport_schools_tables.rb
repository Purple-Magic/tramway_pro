class RemoveSportSchoolsTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :tramway_sport_school_documents
    drop_table :tramway_sport_school_kind_sports
    drop_table :tramway_sport_school_organizations
    drop_table :tramway_sport_school_trainers
  end
end
