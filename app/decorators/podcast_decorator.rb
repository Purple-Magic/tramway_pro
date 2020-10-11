class PodcastDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title

  alias name title
end
