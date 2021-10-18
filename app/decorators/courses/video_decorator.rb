# frozen_string_literal: true

class Courses::VideoDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  decorate_association :comments, as: :associated
  decorate_association :lesson
  decorate_association :time_logs, as: :associated

  delegate_attributes(
    :id,
    :lesson_id,
    :state,
    :position,
    :created_at,
    :updated_at,
    :progress_status,
    :duration
  )

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[lesson_link]
    end

    def show_attributes
      %i[
        id
        lesson_link
        time_logged
        duration
        text
        created_at
        updated_at
        release_date
      ]
    end

    def show_associations
      %i[comments time_logs]
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

  def title
    info = "#{object.comments.active.count} comments | #{object.comments.active.where(comment_state: :done).count} comments done"
    "🎥 Видео #{lesson.topic.position}-#{lesson.position}-#{position} | #{info} | #{object.duration}"
  end

  def release_date
    object.release_date&.strftime('%a, %d.%m.%Y')
  end

  alias name title

  def additional_buttons
    add_scenario_step_url = Tramway::Admin::Engine.routes.url_helpers.new_record_path(
      model: 'Courses::Comment',
      'courses/comment' => { video: object.id }, redirect: "/admin/records/#{object.id}?model=Courses::Video"
    )

    { show: [{ url: add_scenario_step_url, inner: -> { fa_icon :plus }, color: :success }] }
  end

  def link
    ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.id, model: object.class)
  end

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

  def lesson_link
    link_to lesson.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.lesson_id, model: 'Courses::Lesson')
  end

  def time_logged
    content_tag(:ul) do
      object.time_logs.map(&:user).uniq.each do |user|
        concat(content_tag(:li) do
          "#{user.first_name} #{user.last_name} - #{TimeLog.logged_by(user, object)}"
        end)
      end
    end
  end

  # :reek:ControlParameter { enabled: false }
  def video_state_button_color(event)
    case event
    when :write, :shoot
      :primary
    when :finish
      :success
    end
  end
end
