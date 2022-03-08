# frozen_string_literal: true

class Admin::Podcast::Episodes::PartForm < Tramway::Core::ApplicationForm
  properties :project_id, :begin_time, :end_time

  association :episode

  def initialize(object)
    super(object).tap do
      form_properties episode: :association,
        begin_time: :string,
        end_time: :string
    end
  end

  def submit(params)
    old_begin_time = model.begin_time
    old_end_time = model.end_time
    super.tap do |saved|
      if saved && time_changed?(params, old_begin_time, old_end_time)
        model.reload
        Podcasts::Episodes::Parts::GeneratePreviewService.new(model).call
      end
    end
  end

  private

  def time_changed?(params, old_begin_time, old_end_time)
    times_are_nil = old_begin_time.nil? && old_end_time.nil?
    times_are_nil || (old_begin_time != params[:begin_time] || old_end_time != params[:end_time])
  end
end
