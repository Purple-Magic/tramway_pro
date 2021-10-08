# frozen_string_literal: true

class Courses::CommentDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  decorate_association :associated

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
    return object.text unless object.begin_time.present? && object.end_time.present?

    "#{object.begin_time} - #{object.end_time} - #{object.text}"
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
        associated_link
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

  # :reek:ControlParameter { enabled: false }
  def comment_state_button_color(event)
    case event
    when :do_it
      :success
    end
  end
  # :reek:ControlParameter { enabled: true }

  def associated_link
    link_to associated.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.associated_id, model: object.associated_type)
  end
end
