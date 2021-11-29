class AddApprovalStateToBenchkillerOffers < ActiveRecord::Migration[5.1]
  def change
    add_column :benchkiller_offers, :approval_state, :text
  end
end
