class Admin::Products::TaskForm < Tramway::Core::ApplicationForm
  properties :title, :data, :state, :deleted_at, :project_id

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
        data: :string,
        state: :text,
        deleted_at: :date_picker,
        project_id: :integer
    end
  end
end