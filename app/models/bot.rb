class Bot < ApplicationRecord
  has_many :steps, class_name: 'BotTelegram::Scenario::Step'
  has_many :progress_records, through: :steps, class_name: 'BotTelegram::Scenario::ProgressRecord'
  has_many :users, through: :progress_records, class_name: 'BotTelegram::User'

  enumerize :team, in: [ :rsm, :night ]

  [ :rsm, :night ].each do |team|
    scope "#{team}_scope".to_sym, -> (_user_id) do
      where team: team
    end
  end
end
