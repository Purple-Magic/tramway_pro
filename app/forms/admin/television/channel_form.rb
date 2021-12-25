class Admin::Television::ChannelForm < Tramway::Core::ApplicationForm
  properties :title, :channel_type, :rtmp, :project_id

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
        channel_type: :text,
        rtmp: :string,
        project_id: :integer
    end
  end
end