class Podcast::EpisodeForm < Tramway::Core::ApplicationForm
  properties :podcast_id, :number, :project_id
end
