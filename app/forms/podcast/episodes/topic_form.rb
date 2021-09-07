# frozen_string_literal: true

class Podcast::Episodes::TopicForm < Tramway::Core::ApplicationForm
  properties :title, :link, :project_id

  def submit(params)
    model.episode_id = Podcast::Episode.last.id
    model.save!
    time_difference = TimeDifference.between(DateTime.now - Podcast::Episode.last.id.record_time).in_general
    model.timestamp = "#{time_difference[:hours]}:#{time_difference[:minutes]}:#{time_difference[:seconds]}"
    model.save!
    model.discus
    model.save!
    super
  end
end
