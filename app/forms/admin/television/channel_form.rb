class Admin::Television::ChannelForm < Tramway::Core::ApplicationForm
  properties :title, :channel_type, :rtmp, :project_id

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        channel_type: :default,
        rtmp: :text
    end
  end

  def rtmp=(value)
    model.options = YAML.safe_load(value)
  end

  def rtmp
    YAML.dump(model.options).sub("---\n", '')
  end
end
