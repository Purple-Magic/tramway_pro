class ChatQuestUlsk::Game < ApplicationRecord
  state_machine :game_state, initial: :started do
    state :started
    state :finished
  end
end
