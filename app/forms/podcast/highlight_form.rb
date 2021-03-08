# frozen_string_literal: true

class Podcast::HighlightForm < Tramway::Core::ApplicationForm
  properties :episode_id, :time, :project_id

  def episode_id=(value)
    episode = Podcast::Episode.find_by uuid: value
    model.episode_id = episode.id
    model.save
  end
end
