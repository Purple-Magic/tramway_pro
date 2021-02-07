# frozen_string_literal: true

class Episode < ApplicationRecord
  EPISODE_ATTRIBUTES = %i[title season number description published_at image explicit].freeze
end
