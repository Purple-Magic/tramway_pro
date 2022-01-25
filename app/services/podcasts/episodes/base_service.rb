class Podcasts::Episodes::BaseService
  include Podcasts::Episodes::PathManagement
  include Podcasts::Episodes::TimeManagement
  include Ffmpeg::CommandBuilder
  include Podcast::SoundProcessConcern
end