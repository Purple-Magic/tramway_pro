# frozen_string_literal: true

module ::Tramway::Extensions
  def self.load
    Tramway::Event::Event.include Tramway::Event::EventConcern
  end
end

Rails.application.config.after_initialize do
  Tramway::Event::Event.include Tramway::Event::EventConcern
end
