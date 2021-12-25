class Admin::Television::ScheduleItemForm < Tramway::Core::ApplicationForm
  properties :video_id, :schedule_type, :options

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
      form_properties video_id: :integer,
        schedule_type: :text,
        options: :string
    end
  end
end