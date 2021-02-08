# frozen_string_literal: true

class Podcast < ApplicationRecord
  has_many :episodes
end
