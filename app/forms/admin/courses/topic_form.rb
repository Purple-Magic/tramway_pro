class Admin::Courses::TopicForm < Tramway::Core::ApplicationForm
  properties :title, :course_id, :state, :project_id

  def initialize(object)
    super(object).tap do
      # Here is the mapping from model attributes to simple_form inputs.
      # form_properties title: :string,
      #   logo: :file,
      #   description: :ckeditor,
      #   games: :association,
      #   date: :date_picker,
      #   text: :text,
      #   birth_date: {
      #     type: :default,
      #     input_options: {
      #       hint: 'It should be more than 18'
      #     }
      #   }
      form_properties title: :text,
        course_id: :integer,
        state: :text
    end
  end
end
