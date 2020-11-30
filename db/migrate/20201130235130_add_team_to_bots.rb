class AddTeamToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :team, :text
  end
end
