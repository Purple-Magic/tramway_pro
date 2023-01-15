class AddAasmStateToTramwayEventEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_events, :aasm_state, :string
    add_column :tramway_event_participants, :aasm_state, :string
    add_column :tramway_page_pages, :aasm_state, :string
    add_column :tramway_users, :aasm_state, :string
    add_column :courses, :aasm_state, :string
    add_column :courses_comments, :aasm_state, :string
    add_column :courses_topics, :aasm_state, :string
    add_column :courses_lessons, :aasm_state, :string
    add_column :courses_screencasts, :aasm_state, :string
    add_column :courses_tasks, :aasm_state, :string
    add_column :courses_videos, :aasm_state, :string
  end
end
