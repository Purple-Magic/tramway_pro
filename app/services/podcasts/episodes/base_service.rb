class Podcasts::Episodes::BaseService < ApplicationService
  include Podcasts::Episodes::PathManagement
  include Podcasts::Episodes::TimeManagement
  include Podcasts::Episodes::CommandsManagement
  include Podcasts::Episodes::FilesManagement
  include Ffmpeg::CommandBuilder
  include Podcast::SoundProcessConcern
end
