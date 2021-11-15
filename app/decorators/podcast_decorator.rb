# frozen_string_literal: true

class PodcastDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title, :footer

  decorate_associations :stars, :musics, :episodes

  alias name title

  class << self
    def show_associations
      %i[stars musics episodes]
    end
  end
end
