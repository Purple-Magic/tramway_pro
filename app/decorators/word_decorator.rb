# frozen_string_literal: true

class WordDecorator < Tramway::Core::ApplicationDecorator
  class << self
    def collections
      [ :all, :unviewed, :approved ]
    end

    def list_attributes
      [ :synonims, :description ]
    end

    delegate :human_review_state_event_name, to: :model_class
  end

  delegate_attributes :description

  def title
    object.main
  end

  def synonims
    object.synonims&.join(', ')
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
