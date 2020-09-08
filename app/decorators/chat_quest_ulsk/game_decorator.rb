class ChatQuestUlsk::GameDecorator < Tramway::Core::ApplicationDecorator
  def title
    "#{object.quest}: #{user.title} ##{object.id}"
  end

  decorate_associations :user
end
