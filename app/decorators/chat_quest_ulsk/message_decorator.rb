class ChatQuestUlsk::MessageDecorator < Tramway::Core::ApplicationDecorator
  def title
    "#{object.quest}: #{object.text.split(' ')[0..2].join(' ')}..."
  end

  delegate_attributes :quest, :position, :file

  class << self
    def list_attributes
      %i[quest position]
    end
  end
end
