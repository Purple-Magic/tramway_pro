# frozen_string_literal: true

require_relative './messages_manager'
require_relative './info'

module BotTelegram::Scenario
  class << self
    include ::BotTelegram::MessagesManager
    include ::BotTelegram::Info
    include ::BotTelegram::StatsNotifications

    def run(message_from_telegram, bot, bot_record)
      user = user_from message_from_telegram.from
      if message_from_telegram.text == '/start'
        current_step = bot_record.start_step
        send_step_message current_step, bot, message_from_telegram, bot_record
      else
        current_bot_steps = user.progress_records.joins(:step).where(bot_telegram_user_id: user.id)
        current_step = current_bot_steps.where('bot_telegram_scenario_steps.bot_id = ?', bot_record.id).last&.step
        if current_step.present? && current_step.continue?
          next_scenario_step = find_next_scenario_step current_step, message_from_telegram, bot_record
          if next_scenario_step.present?
            send_step_message next_scenario_step, bot, message_from_telegram, bot_record
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
        step: current_step,
        project_id: project.id
      )
      notify_about_finishing_scenario message_from_telegram, bot_record if current_step.finish?

      delay = current_step.delay
      return unless delay.present? && delay != 0

      next_scenario_step = find_next_scenario_step current_step, message_from_telegram, bot_record
      return unless next_scenario_step.present?

      sleep delay
      send_step_message next_scenario_step, bot, message_from_telegram, bot_record
    end

    def find_next_scenario_step(current_step, message_from_telegram, _bot)
      next_scenario_step = nil
      if message_from_telegram.text.present?
        next_scenario_step = current_step.scenario_step_by answer: message_from_telegram.text.downcase
      end
      next_scenario_step ||= current_step.next_scenario_step
      next_scenario_step
    end

    def project
      Project.find_by title: 'PurpleMagic'
    end
  end
end
