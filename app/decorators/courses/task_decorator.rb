# frozen_string_literal: true

class Courses::TaskDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :position,
    :text,
    :max_time,
    :min_time,
    :created_at,
    :updated_at,
    :progress_status
  )

  decorate_association :lesson
  decorate_association :comments, as: :associated

  def title
    info = "#{object.comments.count} comments | #{object.comments.where(comment_state: :done).count} comments done"
    "📝 Задание #{lesson.topic.position}-#{lesson.position}-#{position} | #{info}"
  end

  def lesson_link
    link_to lesson.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.lesson_id, model: 'Courses::Lesson')
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[
        id
        position
        text
        max_time
      ]
    end

    def show_attributes
      %i[
        id
        lesson_link
        position
        text
        max_time
        min_time
        created_at
        updated_at
      ]
    end

    def show_associations
      [:comments]
    end

    def list_filters
      # {
      #   filter_name: {
      #     type: :select,
      #     select_collection: filter_collection,
      #     query: lambda do |list, value|
      #       list.where some_attribute: value
      #     end
      #   },
      #   date_filter_name: {
      #     type: :dates,
      #     query: lambda do |list, begin_date, end_date|
      #       list.where 'created_at > ? AND created_at < ?', begin_date, end_date
      #     end
      #   }
      # }
    end
  end

  def link
    ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.id, model: object.class)
  end

  # :reek:ControlParameter { enabled: false }
  def preparedness_state_button_color(event)
    case event
    when :finish_writing
      :primary
    when :upload
      :success
    end
  end
  # :reek:ControlParameter { enabled: true }

  def text
    marked_text = object.comments.where.not(phrase: nil).reduce(object.text) do |txt, comment|
      comment_html = if comment.file.present?
                       content_tag(:div) do
                         concat comment.text
                         concat content_tag(:br)
                         concat link_to 'Загрузить', comment.file.url
                       end
                     else
                       comment.text
                     end
      txt.sub(
        comment.phrase,
        content_tag(:span, style: 'background-color: yellow; cursor: pointer',
data: { toggle: :popover, html: true, content: comment_html }) do
          comment.phrase
        end.html_safe
      )
    end

    raw marked_text
  end
end
