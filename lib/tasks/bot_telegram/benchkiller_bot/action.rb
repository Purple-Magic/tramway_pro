require 'uri'

class BotTelegram::BenchkillerBot::Action
  include ::BotTelegram::MessagesManager

  attr_reader :message, :user, :chat, :bot, :bot_record

  def initialize(message, user, chat, bot, bot_record)
    @message = message
    @user = user
    @chat = chat
    @bot = bot
    @bot_record = bot_record
  end

  def run
    if user.current_state(bot_record).present? && current_action.present?
      public_send current_action.keys.first, message.text
    end
  end

  def current_action
    BotTelegram::BenchkillerBot::ACTIONS_DATA.select do |action_name, data|
      data[:state] == user.current_state(bot_record).to_sym
    end
  end

  def set_company_name(company_name)
    if company_name.present?
      unless benchkiller_user.present?
        benchkiller_user = ::Benchkiller::User.create! bot_telegram_user_id: user.id,
          project_id: BotTelegram::BenchkillerBot::PROJECT_ID
      end
      company = benchkiller_user.companies.first
      if company.present?
        old_company_name = company.title
        if company.update title: company_name
          message_to_chat bot, chat, "Ваша компания #{old_company_name} переименована в #{company_name} на сервисе Benchkiller"
          user.set_finished_state_for bot: bot_record
        else
          send_message_to_user "К сожалению, ваша компания не переименована. Обратитесь в поддержку сервиса Benchkiller"
        end
      else
        company = ::Benchkiller::Company.create! title: company_name,
          project_id: BotTelegram::BenchkillerBot::PROJECT_ID
        company.companies_users.create! user_id: benchkiller_user.id
        send_message_to_user "Ваша компания #{company_name} успешно создана на Benchkiller"
        user.set_finished_state_for bot: bot_record
      end
    else
      send_message_to_user "Вам следует ввести название компании"
    end
  end

  def set_portfolio_url(portfolio_url)
    if portfolio_url.present? && portfolio_url.scan(URI.regexp)
      if company.update portfolio_url: portfolio_url
        send_message_to_user "Ссылка на портфолио вашей компании успешно обновлена"
      else
        send_message_to_user "К сожалению, не удалось обновить ссылку на портфолио вашей компании. Обратитесь в поддержку сервиса Benchkiller"
      end
    else
      send_message_to_user "Вам следует ввести валидную ссылку на портфолио"
    end
  end

  def set_company_url
  end

  def set_email
  end

  def set_place
  end

  def set_phone
  end

  def set_regions_to_cooperate
  end

  private

  def benchkiller_user
    @benchkiller_user ||= ::Benchkiller::User.active.find_by bot_telegram_user_id: user.id
  end

  def company
    benchkiller_user&.companies.first
  end

  def send_message_to_user(text)
    message_to_chat bot, chat, text
  end
end
