# frozen_string_literal: true

class Podcast::Episodes::Link < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'
end
