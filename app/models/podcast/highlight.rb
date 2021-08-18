# frozen_string_literal: true

class Podcast::Highlight < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'

  scope :podcast_scope, ->(_user_id) { all }

  enumerize :using_state, in: %i[using not_using], default: :not_using

  uploader :file, :file
  uploader :ready_file, :file
end
