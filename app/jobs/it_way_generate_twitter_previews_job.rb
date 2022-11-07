# frozen_string_literal: true

class ItWayGenerateTwitterPreviewsJob < ActiveJob::Base
  queue_as :default

  def perform(*_args)
    ItWay::Person.find_each do |person|
      path = "twitter-preview-person-#{person.id}.png"
      system "cutycapt --url=http://it-way.pro/people/previews/#{person.id} --out=#{path}"

      sleep 60

      person.update! twitter_preview: path
    end
  end
end
