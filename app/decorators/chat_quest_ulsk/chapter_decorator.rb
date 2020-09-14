class ChatQuestUlsk::ChapterDecorator < Tramway::Core::ApplicationDecorator
  def title
    "#{object.quest} ##{object.position}"
  end
end
