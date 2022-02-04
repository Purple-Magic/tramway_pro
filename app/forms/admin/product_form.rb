class Admin::ProductForm < Tramway::Core::ApplicationForm
  properties :title, :project_id, :tech_name

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        tech_name: :string
    end
  end
end
