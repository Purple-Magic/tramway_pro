class Admin::Podcast::StarForm < Tramway::Core::ApplicationForm
  properties :nickname, :link, :project_id

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        nickname: :string,
        link: :string
    end
  end
end
