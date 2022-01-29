class Admin::Products::TaskForm < Tramway::Core::ApplicationForm
  properties :title, :project_id

  association :product

  def initialize(object)
    super(object).tap do
      form_properties product: :association,
        title: :string
    end
  end
end
