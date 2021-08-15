# frozen_string_literal: true

class Courses::CommentDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  decorate_association :video

  delegate_attributes(
    :id,
    :video_id,
    :begin_time,
    :end_time,
    :state,
    :text,
    :created_at,
    :updated_at
  )

  def title
    return '' unless object.begin_time.present? && object.end_time.present?

    "#{object.begin_time} - #{object.end_time} - "
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[
        id
        video_id
        begin_time
        end_time
      ]
    end

    def show_attributes
      %i[
        id
        video_id
        begin_time
        end_time
        file
        video_link
        text
        state
        created_at
        updated_at
      ]
    end
  end

  def file
    file_view object.file
  end

  def comment_state_button_color(event)
    case event
    when :do_it
      :success
    end
  end

  def video_link
    link_to video.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.video_id, model: 'Courses::Video')
  end
end
