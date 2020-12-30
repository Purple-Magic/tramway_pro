class Admin::Estimation::TaskForm < Tramway::Core::ApplicationForm
  properties :title, :hours, :price, :project_id

  association :estimation_project

  def initialize(object)
    super(object).tap do
      form_properties estimation_project: :association,
        title: :string,
        hours: :numeric,
        price: :numeric
    end
  end
end
