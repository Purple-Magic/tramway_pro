module ChatQuestUlsk
  module Errors
    def send_error(bot, error_message, message_obj)
      message_to_user bot, error_message, message_obj
      BotTelegram::Message.create! text: error_message
    end
  end
end
