# frozen_string_literal: true

require_relative './messages_manager'
require_relative './info'

module BotTelegram::Scenario
  class << self
    include ::BotTelegram::MessagesManager
    include ::BotTelegram::Info

    def run(message_from_telegram, bot, bot_record)
      user = user_from message_from_telegram.from
      if message_from_telegram.text == '/start'
        current_step = bot_record.steps.active.find_by(name: :start)
        send_step_message current_step, bot, message_from_telegram, bot_record
      else
        current_bot_steps = user.progress_records.joins(:step).where(bot_telegram_user_id: user.id)
        current_step = current_bot_steps.where('bot_telegram_scenario_steps.bot_id = ?', bot_record.id).last&.step
        if current_step.present? && current_step.continue?
          next_step = find_next_step current_step, message_from_telegram, bot_record
          if next_step.present?
            send_step_message next_step, bot, message_from_telegram, bot_record
          else
            error = make_error current_step, bot_record
            message_to_user bot.api, error, message_from_telegram.chat.id
          end
        end
      end
    end

    def make_error(current_step, bot_record)
      bot_options = bot_record.options
      if current_step.options['free_answer']
        bot_options['standard_answer'] || 'Я запомнил это сообщение'
      else
        (bot_options.present? && bot_options['standard_error']) || I18n.t('bot.standard_error')
      end
    end

    def send_step_message(current_step, bot, message_from_telegram, bot_record)
      message_to_user bot.api, current_step, message_from_telegram.chat.id
      BotTelegram::Scenario::ProgressRecord.create!(
        bot_telegram_user_id: user_from(message_from_telegram.from).id,
        bot_telegram_scenario_step_id: current_step.id,
        project_id: project.id
      )

      delay = current_step.delay
      return unless delay.present? && delay != 0

      next_step = find_next_step current_step, message_from_telegram, bot_record
      return unless next_step.present?

      sleep delay
      send_step_message next_step, bot, message_from_telegram, bot_record
    end

    def find_next_step(current_step, message_from_telegram, bot)
      next_step = nil
      if message_from_telegram.text.present?
        next_step = bot.steps.active.find_by(name: current_step.options[message_from_telegram.text.downcase])
      end
      next_step ||= bot.steps.active.find_by name: current_step.options['next']
      next_step
    end

    CURRENT_PURPLE_MAGIC_PROJECT_ID = 7

    def project
      Project.find CURRENT_PURPLE_MAGIC_PROJECT_ID
    end
  end
end
