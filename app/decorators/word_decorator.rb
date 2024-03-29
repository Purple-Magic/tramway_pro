# frozen_string_literal: true

class WordDecorator < ApplicationDecorator
  class << self
    def collections
      %i[all unviewed approved]
    end

    def list_attributes
      %i[synonims description]
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

  # :reek:ControlParameter { enabled: false }
  def review_state_button_color(event)
    case event
    when :approve
      :success
    when :revoke
      :warning
    end
  end
end
