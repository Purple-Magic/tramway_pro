class Podcast::Youtube::VideoDecorator < ApplicationDecorator
  decorate_association :stars, as: :episode
  decorate_association :podcast
  decorate_association :topics, as: :episode
  decorate_association :links, as: :episode
  decorate_association :instances, as: :episode

  def description
    raw Podcasts::Youtube::DescriptionBuilder.new(self, format: :text).call
  end
end
