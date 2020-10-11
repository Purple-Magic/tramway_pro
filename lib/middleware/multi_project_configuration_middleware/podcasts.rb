# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Podcasts
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Admin::PodcastForm.include MultiProjectCallbacks::PodcastCallbacks::PodcastForm
      ::Podcast.include MultiProjectCallbacks::PodcastCallbacks::PodcastConcern
      #::Admin::EpisodeForm.include MultiProjectCallbacks::EpisodeCallbacks::EpisodeForm
      ::Episode.include MultiProjectCallbacks::EpisodeCallbacks::EpisodeConcern


      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module PodcastCallbacks
    module PodcastForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module PodcastConcern
      extend ActiveSupport::Concern

      included do
        default_scope do
          where project_id: Project.where(url: ENV['PROJECT_URL'])
        end
      end
    end
  end

  module EpisodeCallbacks
    module EpisodeForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module EpisodeConcern
      extend ActiveSupport::Concern

      included do
        default_scope do
          where project_id: Project.where(url: ENV['PROJECT_URL'])
        end
      end
    end
  end
end
