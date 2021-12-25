class Admin::Television::ScheduleItemForm < Tramway::Core::ApplicationForm
  properties :schedule_type, :options, :project_id

  association :video
  association :channel

  def initialize(object)
    super(object).tap do
      form_properties channel: :association,
        video: :association,
        schedule_type: :default,
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
