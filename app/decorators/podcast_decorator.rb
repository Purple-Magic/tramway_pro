class PodcastDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title
end
