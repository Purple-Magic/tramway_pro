class ChatQuestUlsk::Message < ApplicationRecord
  enumerize :area, in: ['Ленинский', 'Засвияжский', 'Заволжский', 'Железнодорожный']
end
