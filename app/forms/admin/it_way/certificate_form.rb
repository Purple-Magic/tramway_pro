# frozen_string_literal: true

class Admin::ItWay::CertificateForm < Tramway::Core::ApplicationForm
  properties :text, :certificate_type

  association :event

  def initialize(object)
    super(object).tap do
      form_properties text: :ckeditor,
        certificate_type: :default,
        event: :association
    end
  end
end
