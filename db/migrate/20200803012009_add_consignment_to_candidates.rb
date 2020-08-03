class AddConsignmentToCandidates < ActiveRecord::Migration[5.1]
  def change
    add_column :elections_candidates, :consignment, :text
  end
end
