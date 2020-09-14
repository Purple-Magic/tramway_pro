class ChatQuestUlsk::Message < ApplicationRecord
  belongs_to :chapter, class_name: 'ChatQuestUlsk::Chapter'

  uploader :file, :file, extensions: %i[mp3 wav jpg jpeg png]

  search_by :text, :quest, :answer
end
