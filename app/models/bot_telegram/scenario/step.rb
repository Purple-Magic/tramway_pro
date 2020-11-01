class BotTelegram::Scenario::Step < ApplicationRecord
  belongs_to :bot

  uploader :file, :file, extensions: %i[mp3 wav jpg jpeg png]

  scope :partner_scope, -> { all }
end
