class ChatQuestUlsk::Message < ApplicationRecord
  enumerize :quest, in: [ :love ]

  uploader :file, :file, extensions: [ :mp3, :wav, :jpg, :jpeg, :png ]
end
