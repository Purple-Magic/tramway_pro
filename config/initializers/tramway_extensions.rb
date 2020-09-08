# frozen_string_literal: true

module ::Tramway::Extensions
  def self.load
    Tramway::Event::Event.include Tramway::Event::EventConcern
    Tramway::User::User.include Tramway::User::UserConcern
  end
end

Tramway::Event::Event.include Tramway::Event::EventConcern
