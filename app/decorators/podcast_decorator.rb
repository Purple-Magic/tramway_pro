# frozen_string_literal: true

class PodcastDecorator < ApplicationDecorator
  delegate_attributes :title, :footer, :youtube_footer

  decorate_associations :stars, :musics, :episodes

  alias name title

  class << self
    def show_associations
      %i[stars musics episodes]
    end
  end
end
