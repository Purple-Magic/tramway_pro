# frozen_string_literal: true

class BotTelegram::Leopold::Message
  def initialize(file)
    @message = OpenStruct.new(
      file: OpenStruct.new(file: OpenStruct.new(file: file)),
      reply_markup: nil
    )
  end
end
