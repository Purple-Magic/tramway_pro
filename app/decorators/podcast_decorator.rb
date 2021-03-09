# frozen_string_literal: true

class PodcastDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title

  decorate_association :episodes

  alias name title

  class << self
    def show_associations
      [:episodes]
    end
  end
end
