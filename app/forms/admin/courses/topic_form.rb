class Admin::Courses::TopicForm < Tramway::Core::ApplicationForm
  properties :title, :state, :project_id

  association :course

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        course: :association
    end
  end
end
