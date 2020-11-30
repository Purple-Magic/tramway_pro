class BotTelegram::Scenario::Step < ApplicationRecord
  belongs_to :bot

  uploader :file, :file, extensions: %i[mp3 wav jpg jpeg png]

  scope :partner_scope, -> (_user_id) { all }
  scope :rsm_scope, -> (_user_id) { joins(:bot).where('bots.team = ?', :rsm) }

  def continue?
    options.present?
  end
end
