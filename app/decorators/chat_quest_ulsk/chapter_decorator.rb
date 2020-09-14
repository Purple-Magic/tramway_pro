class ChatQuestUlsk::ChapterDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :answers

  class << self
    def list_attributes
      [:answers]
    end
  end

  def title
    "#{object.quest} ##{object.position}"
  end
end
