# frozen_string_literal: true

class Podcast < ApplicationRecord
  has_many :episodes, class_name: 'Podcast::Episode'
end
