# frozen_string_literal: true

class PodcastDecorator < ApplicationDecorator
  delegate_attributes :title, :footer, :youtube_footer

  decorate_associations :stars, :musics, :episodes

  alias name title

  include Concerns::TimeLogsTable

  class << self
    def show_associations
      %i[stars musics episodes]
    end

    def show_attributes
      [:time_logs]
    end
  end
end
