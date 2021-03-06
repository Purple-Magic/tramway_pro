# frozen_string_literal: true

class ItWay::CertificateDecorator < Tramway::Core::ApplicationDecorator
  def title
    "#{object.event.title}: #{object.certificate_type}"
  end
end
