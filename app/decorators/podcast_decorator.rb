# frozen_string_literal: true

class PodcastDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title

  decorate_association :episodes

  alias name title
end
