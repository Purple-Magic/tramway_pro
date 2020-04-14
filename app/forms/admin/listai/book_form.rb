class Admin::Listai::BookForm < Tramway::Core::ApplicationForm
  properties :title

  def initialize(object)
    super(object).tap do
      form_properties title: :string
    end
  end
end
