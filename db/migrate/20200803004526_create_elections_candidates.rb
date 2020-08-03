class CreateElectionsCandidates < ActiveRecord::Migration[5.1]
  def change
    create_table :elections_candidates do |t|
      t.text :full_name
      t.text :description
      t.integer :area

      t.timestamps
    end
  end
end
