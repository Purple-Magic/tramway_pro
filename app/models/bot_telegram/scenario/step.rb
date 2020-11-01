class BotTelegram::Scenario::Step < ApplicationRecord
  belongs_to :bot

  uploader :file, :file, extensions: %i[mp3 wav jpg jpeg png]
end
