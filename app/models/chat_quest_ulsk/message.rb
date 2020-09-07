class ChatQuestUlsk::Message < ApplicationRecord
  enumerize :area, in: ['Ленинский', 'Засвияжский', 'Заволжский', 'Железнодорожный']

  uploader :file, :file
end
