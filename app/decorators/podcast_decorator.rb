# frozen_string_literal: true

class PodcastDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title

  decorate_associations :musics, :episodes

  alias name title

  class << self
    def show_associations
      %i[musics episodes]
    end
  end
end
