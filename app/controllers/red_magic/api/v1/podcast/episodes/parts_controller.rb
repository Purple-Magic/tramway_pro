class RedMagic::Api::V1::Podcast::Episodes::PartsController < RedMagic::Api::V1::Podcast::Episodes::ApplicationController
  def index
    episode = ::Podcast::Episode.find params[:id]
    files = Dir["#{episode.parts_directory_name}/*.mp3"]
    system "zip #{episode.parts_directory_name}/parts.zip #{files.join(' ')}"

    sleep 5
    
    send_file "#{episode.parts_directory_name}/parts.zip"
  end
end
