class PodcastsSavingVideoAfterRender < ActiveJob::Base
  queue_as :default

  def perform(*_args)
  end
end
