class Admin::Podcast::ChannelForm < Tramway::Core::ApplicationForm
  properties :service, :title, :project_id, :channel_id, :options

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        service: :default,
        title: :string,
        channel_id: :string,
        options: :text
    end
  end

  def options=(value)
    model.options = YAML.safe_load(value)
  end

  def options
    YAML.dump(model.options).sub("---\n", '')
  end
end
