module RedMagic
  module Api
    module V1
      module Podcast
        module Episodes
          class PartsController < RedMagic::Api::V1::ApplicationController
            def index
              episode = ::Podcast::Episode.find_by params[:id]
              files = Dir["#{episode.parts_directory_name}/*.mp3"]
              system "zip #{files.join(' ')}"
            end
          end
        end
      end
    end
  end
