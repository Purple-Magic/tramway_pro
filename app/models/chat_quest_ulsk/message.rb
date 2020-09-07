class ChatQuestUlsk::Message < ApplicationRecord
  enumerize :area, in: ['Ленинский', 'Засвияжский', 'Заволжский', 'Железнодорожный']

  uploader :file, :file, extensions: [ :mp3, :wav, :jpg, :jpeg, :png ]
end
