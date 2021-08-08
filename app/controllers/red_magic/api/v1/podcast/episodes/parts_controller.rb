# frozen_string_literal: true

class RedMagic::Api::V1::Podcast::Episodes::PartsController < RedMagic::Api::V1::Podcast::Episodes::ApplicationController
  def index
    episode = ::Podcast::Episode.find params[:id]
    files = Dir["#{episode.parts_directory_name}/part*.mp3"]
    command = "cd #{episode.parts_directory_name} && zip parts.zip #{files.join(' ')}"
    Rails.logger.info command
    system command

    sleep 5

    send_file "#{episode.parts_directory_name}/parts.zip"
  end
end
