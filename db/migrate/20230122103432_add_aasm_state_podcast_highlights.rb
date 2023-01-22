class AddAasmStatePodcastHighlights < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_highlights, :aasm_state, :string
  end
end
