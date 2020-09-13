class ChatQuestUlsk::Message < ApplicationRecord
  enumerize :quest, in: %i[love detective horror fantasy]

  uploader :file, :file, extensions: %i[mp3 wav jpg jpeg png]

  search_by :text, :quest, :answer
end
