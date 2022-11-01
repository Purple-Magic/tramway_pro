class AddContentTypeToItWayParticipations < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_participations, :content_type, :text
  end
end
