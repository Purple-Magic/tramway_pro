class BotTelegram::Scenario::Step < ApplicationRecord
  uploader :file, :file, extensions: %i[mp3 wav jpg jpeg png]
end
