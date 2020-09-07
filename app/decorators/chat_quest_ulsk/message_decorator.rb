class ChatQuestUlsk::MessageDecorator < Tramway::Core::ApplicationDecorator
  def title
    "#{object.area}: #{object.text.split(' ')[0..2].join(' ')}..."
  end

  delegate_attributes :area, :position

  class << self
    def list_attributes
      [ :area, :position ]
    end
  end
end
