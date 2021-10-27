class AddReviewStateToBenchkillerCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :benchkiller_companies, :review_state, :text, default: :unviewed
  end
end
