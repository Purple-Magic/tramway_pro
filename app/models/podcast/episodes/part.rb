# frozen_string_literal: true

class Podcast::Episodes::Part < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'

  uploader :preview, :file

  include Podcast::SoundProcessConcern
end
