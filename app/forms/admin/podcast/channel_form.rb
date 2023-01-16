class Admin::Podcast::ChannelForm < Tramway::ApplicationForm
  properties :service, :title, :project_id, :channel_id, :options, :footer

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        service: :default,
        title: :string,
        channel_id: :string,
        options: :text,
        footer: :text
    end
  end

  def options=(value)
    model.options = YAML.safe_load(value)
  end

  def options
    YAML.dump(model.options).sub("---\n", '')
  end
end
