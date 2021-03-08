class Podcast::EpisodeForm < Tramway::Core::ApplicationForm
  properties :podcast_id, :number, :project_id, :file

  def podcast_id=(value)
    podcast = Podcast.find_by uuid: value
    model.podcast_id = podcast.id
    model.save
  end
end
