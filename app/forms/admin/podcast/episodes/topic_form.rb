class Admin::Podcast::Episodes::TopicForm < Tramway::Core::ApplicationForm
  properties :episode_id, :title, :link, :state, :project_id, :discus_state, :timestamp

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
      form_properties episode_id: :integer,
        title: :text,
        link: :text,
        state: :text,
        project_id: :integer,
        discus_state: :text,
        timestamp: :text
    end
  end
end