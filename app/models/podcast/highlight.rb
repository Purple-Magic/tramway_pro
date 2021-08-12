# frozen_string_literal: true

class Podcast::Highlight < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'

  enumerize :using_state, in: [ :using, :not_using ], default: :not_using

  uploader :file, :file
end
