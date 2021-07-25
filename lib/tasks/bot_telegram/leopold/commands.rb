# frozen_string_literal: true

module BotTelegram::Leopold::Commands
  def add_word(text)
    if condition_to_action? text, :add_word
      words = Word.find_records_by(text, Word.active)
      if words.any?
        message_to_chat bot, chat, bot_record.options['i_have_this_word']
      else
        word = Word.create! main: text, review_state: :unviewed, project_id: 2
        word.audits.last.update! user_id: chat.telegram_chat_id
        message_to_chat bot, chat, bot_record.options['now_add_description_to_this_word']
      end
    else
      empty_word_message
    end
  end

  def add_description(text)
    binding.pry
    if condition_to_action? text, :add_description
      word = Word.includes(:audits).where(audits: { user_id: chat.telegram_chat_id }, description: nil).last
      if word.present?
        word.update! description: text
        message_to_chat bot, chat, bot_record.options['we_will_review_it']
      else
        message_to_chat bot, chat, bot_record.options['looks_like_you_did_not_create_any_word']
      end
    else
      empty_word_message
    end
  end

  private

  def condition_to_action?(text, command)
    !text.in? ["/#{command}@myleopold_bot", "/#{command}"]
  end

  def empty_word_message
    message_to_chat bot, chat, bot_record.options['empty_word']
  end
end
