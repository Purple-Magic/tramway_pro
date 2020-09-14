class ChatQuestUlsk::Chapter < ApplicationRecord
  has_many :message, class_name: 'ChatQuestUlsk::Message'

  enumerize :quest, in: %i[love detective horror fantasy]
end
