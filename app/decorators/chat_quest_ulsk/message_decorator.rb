class ChatQuestUlsk::MessageDecorator < Tramway::Core::ApplicationDecorator
  def title
    "#{object.area}: #{object.text.first(15)}..."
  end

  delegate_attributes :area

  class << self
    def list_attributes
      [ :area ]
    end
  end
end
