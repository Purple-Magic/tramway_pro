class Admin::ProductForm < Tramway::Core::ApplicationForm
  properties :title, :project_id

  def initialize(object)
    super(object).tap do
      form_properties title: :string
    end
  end
end
