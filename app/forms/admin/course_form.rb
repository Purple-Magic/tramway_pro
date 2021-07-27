class Admin::CourseForm < Tramway::Core::ApplicationForm
  properties :title, :state, :project_id

  def initialize(object)
    super(object).tap do
      form_properties title: :string
    end
  end
end
