class Podcast::Episodes::TopicSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :title, :link
end
