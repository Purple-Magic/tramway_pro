class Admin::ItWay::CertificateForm < Tramway::Core::ApplicationForm
  properties :text, :certificate_type
  
  association :event

  def initialize(object)
    super(object).tap do
      form_properties text: :ckeditor,
        certificate_type: :string,
        event: :association
    end
  end
end
