class Admin::Products::TaskForm < Tramway::Core::ApplicationForm
  properties :title, :project_id, :estimation, :description

  association :product

  def initialize(object)
    super(object).tap do
      form_properties product: :association,
        title: :string,
        estimation: :string,
        description: :text
    end
  end
end
