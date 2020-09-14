class ChatQuestUlsk::MessageDecorator < Tramway::Core::ApplicationDecorator
  def title
    "#{object.quest}: #{object.text.split(' ')[0..2].join(' ')}..."
  end

  delegate_attributes :position, :file

  decorate_association :chapter

  def chapter_title
    chapter.title
  end

  class << self
    def list_attributes
      %i[chapter_title position]
    end
  end
end
