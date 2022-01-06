# frozen_string_literal: true

module Courses::DecoratorHelpers::Data
  def data_table_header
    concat(content_tag(:thead) do
      concat(content_tag(:th) do
        'Количество видео'
      end)
      concat(content_tag(:th) do
        'Продолжительность видео'
      end)
      concat(content_tag(:th) do
        'Количество задач'
      end)
      concat(content_tag(:th) do
        'Продолжительность задач'
      end)
    end)
  end

  def data_table_body
    concat(content_tag(:tr) do
      concat(content_tag(:td) do
        object.videos.count.to_s
      end)
      concat(content_tag(:td) do
        object.video_duration
      end)
      concat(content_tag(:td) do
        object.tasks.count.to_s
      end)
      concat(content_tag(:td) do
        object.tasks_duration
      end)
    end)
  end
end
