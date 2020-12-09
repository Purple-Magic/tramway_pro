class Bot < ApplicationRecord
  has_many :steps, class_name: 'BotTelegram::Scenario::Step'

  enumerize :team, in: [ :rsm, :night ]

  [ :rsm, :night ].each do |team|
    scope "#{team}_scope".to_sym, -> (_user_id) do
      where team: team
    end
  end
end
