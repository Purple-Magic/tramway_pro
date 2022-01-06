# frozen_string_literal: true

class ItWay::CertificateDecorator < ApplicationDecorator
  def title
    "#{object.event.title}: #{object.certificate_type}"
  end
end
