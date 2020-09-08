class ChatQuestUlsk::Game < ApplicationRecord
  state_machine :game_state, initial: :started do
    state :started
    state :finished

    event :finish do
      transition started: :finished
    end
  end
end
