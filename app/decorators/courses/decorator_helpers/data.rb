# frozen_string_literal: true

module Courses::DecoratorHelpers::Data
  def data_table_header
    concat(content_tag(:thead) do
      concat(th do
        'Количество видео'
      end)
      concat(th do
        'Предположительная продолжительность видео'
      end)
      concat(th do
        'Отснято'
      end)
      if object.tasks.any?
        concat(th do
          'Количество задач'
        end)
        concat(th do
          'Продолжительность задач'
        end)
      end
    end)
  end

  def data_table_body
    concat(content_tag(:tr) do
      concat(td do
        object.videos.count.to_s
      end)
      concat(td do
        object.video_duration_for(duration: :duration)
      end)
      concat(td do
        object.video_duration_for(duration: :result_duration)
      end)
      if object.tasks.any?
        concat(td do
          object.tasks.count.to_s
        end)
        concat(td do
          object.tasks_duration
        end)
      end
    end)
  end
end
