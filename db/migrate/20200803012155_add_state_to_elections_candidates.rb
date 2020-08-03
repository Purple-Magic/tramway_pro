class AddStateToElectionsCandidates < ActiveRecord::Migration[5.1]
  def change
    add_column :elections_candidates, :state, :text
    add_column :elections_candidates, :project_id, :integer
  end
end
