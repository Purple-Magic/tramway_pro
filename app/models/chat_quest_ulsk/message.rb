class ChatQuestUlsk::Message < ApplicationRecord
  enumerize :quest, in: [ :love, :detective, :horror, :fantasy ]

  uploader :file, :file, extensions: [ :mp3, :wav, :jpg, :jpeg, :png ]
end
