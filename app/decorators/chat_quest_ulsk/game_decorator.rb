class ChatQuestUlsk::GameDecorator < Tramway::Core::ApplicationDecorator
  class << self
    delegate :human_game_state_event_name, to: :model_class

    def show_attributes
      [ :chat ]
    end
  end

  def title
    "#{object.quest}: #{user.first_name} #{user.last_name} ##{object.id}"
  end

  decorate_associations :user

  def chat
    content_tag :table do
      object.messages.each do |message|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            case message.class.to_s
            when 'ChatQuestUlsk::Message'
              'Bot'
            when 'BotTelegram::Message'
              if message.user.present?
                "#{message.user.first_name} #{message.user.last_name}"
              else
                'Bot'
              end
            end
          end)
          concat(content_tag(:td) do
            case message.class.to_s
            when 'ChatQuestUlsk::Message'
              message.text.present? ? message.text : '[файл]'
            when 'BotTelegram::Message'
              message.text
            end
          end)
          concat(content_tag(:td) do
            message.created_at.strftime('%d.%m.%Y %H:%M:%S')
          end)
        end)
      end
    end
  end

  def game_state_button_color(event)
    case event
    when :finish
      :success
    end
  end
end
