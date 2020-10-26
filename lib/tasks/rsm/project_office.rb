module RSM
  module ProjectOffice
    class << self
      include BotTelegram::MessagesManager

      def scenario(message_from_telegram, bot)
        if message_from_telegram.text == '/start'
          file_path = "#{Rails.root}/lib/tasks/rsm/messages.yml"
          messages = YAML.load_file(file_path)['messages'].with_indifferent_access
          message_to_user bot, messages[:start], message_from_telegram

          sleep 3

          message = BotTelegram::MessageBuilder.new messages[:do_you_have_project]
          message_to_user bot, message, message_from_telegram
        end
      end
    end
  end
end
