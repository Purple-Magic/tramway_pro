class AddMoreAttributesToScreencasts < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_screencasts, :begin_time, :text
    add_column :courses_screencasts, :end_time, :text
    add_column :courses_screencasts, :file, :text
  end
end
