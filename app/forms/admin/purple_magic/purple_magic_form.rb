class Admin::PurpleMagic::PurpleForm < Tramway::Core::ApplicationForm
  properties :title, :description, :text, :date, :logo

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
                      logo: :file,
                      description: :ckeditor,
                      date: :date_picker,
                      text: :text
    end
  end
end
