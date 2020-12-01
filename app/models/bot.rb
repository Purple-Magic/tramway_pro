class Bot < ApplicationRecord
  has_many :steps, class_name: 'BotTelegram::Scenario::Step'

  enumerize :team, in: [ :rsm, :night ]
end
