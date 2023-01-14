# frozen_string_literal: true

class Podcast::Episodes::Topic < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'

  scope :podcast_scope, ->(_user_id) { all }

  aasm column: :discus_state do
    state :current_episode, initial: true
    state :discussed

    event :discus do
      transitions to: :discussed
    end
  end
end
