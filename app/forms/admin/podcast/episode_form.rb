class Admin::Podcast::EpisodeForm < Tramway::Core::ApplicationForm
  properties :project_id, :file

  def initialize(object)
    super(object).tap do
      form_properties file: :file
    end
  end
end
