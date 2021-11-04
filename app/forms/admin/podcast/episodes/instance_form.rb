class Admin::Podcast::Episodes::InstanceForm < Tramway::Core::ApplicationForm
  properties :state, :project_id, :service, :link

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
      form_properties state: :text,
        project_id: :integer,
        service: :text,
        link: :text
    end
  end
end