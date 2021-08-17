# frozen_string_literal: true

class Podcast::EpisodeForm < Tramway::Core::ApplicationForm
  properties :podcast_id, :number, :project_id, :file, :montage_state

  def podcast_id=(value)
    podcast = Podcast.find_by uuid: value
    model.podcast_id = podcast.id
    model.save
  end

  def submit(params)
    if model.montage_state == 'ready_to_start' && params['montage_state'] == 'recording'
      model.record_time = DateTime.now
      model.save
    end
    super
  end
end
