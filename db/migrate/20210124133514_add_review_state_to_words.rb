class AddReviewStateToWords < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :review_state, :text, default: :approved
  end
end
