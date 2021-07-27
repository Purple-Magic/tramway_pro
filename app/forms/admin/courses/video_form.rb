class Admin::Courses::VideoForm < Tramway::Core::ApplicationForm
  properties :lesson_id, :text, :state, :project_id

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
      form_properties lesson_id: :integer,
        text: :text,
        state: :text
    end
  end
end
