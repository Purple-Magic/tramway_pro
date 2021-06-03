class RedMagic::Api::V1::Podcast::Episodes::PartsController < RedMagic::Api::V1::ApplicationController
  def index
    episode = ::Podcast::Episode.find_by params[:id]
    files = Dir["#{episode.parts_directory_name}/*.mp3"]
    system "zip #{files.join(' ')}"
  end
end
