# frozen_string_literal: true

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
    model.rtmp = YAML.safe_load(value)
  end

  def rtmp
    YAML.dump(model.rtmp).sub("---\n", '')
  end
end
