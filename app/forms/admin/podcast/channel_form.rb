class Admin::Podcast::ChannelForm < Tramway::Core::ApplicationForm
  properties :service, :title, :project_id, :channel_id

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        service: :default,
        title: :string,
        channel_id: :string
    end
  end
end
