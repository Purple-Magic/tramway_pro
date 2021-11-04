class Admin::Podcast::Episodes::StarForm < Tramway::Core::ApplicationForm
  properties :star_type, :project_id

  association :episode
  association :star

  def initialize(object)
    super(object).tap do
      form_properties episode: :association,
        star: :association,
        star_type: :default
    end
  end
end
