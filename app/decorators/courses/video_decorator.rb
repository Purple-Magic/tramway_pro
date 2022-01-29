# frozen_string_literal: true

class Courses::VideoDecorator < ApplicationDecorator
  # Associations you want to show in admin dashboard
  decorate_association :comments, as: :associated
  decorate_association :lesson
  decorate_association :screencasts, as: :video
  decorate_association :time_logs, as: :associated

  delegate_attributes :id, :lesson_id, :state, :position, :created_at, :updated_at, :progress_status, :duration,
    :result_duration

  def course_link
    link_to(
      lesson.topic.course.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.lesson.topic.course_id, model: 'Course')
    )
  end

  def auto_estimated_time
    coefficients = Courses::Video.where.not(result_duration: nil).map do |video|
      if video.result_duration.present?
        video.minutes_of(:result_duration).to_f / video.text.split.count
      end
    end.compact
    if coefficients.any? && object.text.present?
      estimated_duraion = (object.text.split.count * coefficients.median).round 2
      minutes = estimated_duraion.to_s.split('.').first
      fraction = (estimated_duraion.to_s.split('.').second.to_i * 60 / 100).round
      "#{minutes}m #{fraction}s"
    else
      "0m"
    end
  end

  def url
    link_to object.url, object.url, target: '_blank' if object.url.present?
  end

  class << self
    def collections
      [:all]
    end

    def list_attributes
      %i[lesson_link]
    end

    def show_attributes
      %i[course_link lesson_link time_logged duration result_duration auto_estimated_time url text created_at
         updated_at release_date]
    end

    def show_associations
      %i[comments screencasts time_logs]
    end

    def list_filters; end
  end

  def title
    info = "#{object.comments.count} comments | #{object.comments.where(comment_state: :done).count} comments done"
    duration_to_show = object.result_duration.present? ? object.result_duration : object.duration
    "🎥 Видео #{lesson.topic.position}-#{lesson.position}-#{position} | #{info} | #{duration_to_show}"
  end

  def release_date
    object.release_date&.strftime('%a, %d.%m.%Y')
  end

  alias name title

  def additional_buttons
    add_comment_url = Tramway::Admin::Engine.routes.url_helpers.new_record_path(
      model: 'Courses::Comment',
      'courses/comment' => { associated_type: object.class.to_s, associated: object.id },
      redirect: "/admin/records/#{object.id}?model=Courses::Video"
    )
    add_time_log_url = Tramway::Admin::Engine.routes.url_helpers.new_record_path(
      model: 'TimeLog',
      'time_log' => { associated_type: object.class.to_s, associated: object.id },
      redirect: "/admin/records/#{object.id}?model=Courses::Video"
    )

    {
      show: [
        { url: add_comment_url, inner: -> { fa_icon 'comment' }, color: :success },
        { url: add_time_log_url, inner: -> { fa_icon 'clock' }, color: :success }
      ]
    }
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
    when :write, :shoot, :upload
      :primary
    when :finish
      :success
    end
  end
end
