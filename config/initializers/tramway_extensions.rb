# frozen_string_literal: true

module ::Tramway::Extensions
  def self.load
    Tramway::Event::Event.include Tramway::Event::EventConcern
    Audited::Audit.include Audited::AuditConcern
  end
end

Tramway::Event::Event.include Tramway::Event::EventConcern
Audited::Audit.include Audited::AuditConcern
