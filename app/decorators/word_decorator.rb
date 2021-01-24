# frozen_string_literal: true

class WordDecorator < Tramway::Core::ApplicationDecorator
  class << self
    def collections
      [ :unviewed, :approved, :all ]
    end

    delegate :human_review_state_event_name, to: :model_class
  end

  def title
    object.main
  end

  def review_state_button_color(event)
    case event
    when :approve
      :success
    when :revoke
      :warning
    end
  end
end
