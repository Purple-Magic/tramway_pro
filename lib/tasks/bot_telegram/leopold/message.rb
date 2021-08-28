# frozen_string_literal: true

class BotTelegram::Leopold::Message
  attr_reader :file

  def initialize(file)
    @file = OpenStruct.new(
      file: OpenStruct.new(file: OpenStruct.new(file: file)),
      reply_markup: nil
    )
  end
end
