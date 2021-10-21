class BotTelegram::BenchkillerBot::Action
  include ::BotTelegram::MessagesManager

  STATES_ACTIONS_RELATION = {
    waiting_for_set_company_name: :set_company_name
  }

  attr_reader :message, :user, :chat, :bot

  def initialize(message, user, chat, bot)
    @message = message
    @user = user
    @chat = chat
    @bot = bot
  end

  def run
    if user.current_state.present? && current_action(user).present?
      public_send current_action(user), message.text
    end
  end

  def current_action(user)
    STATES_ACTIONS_RELATION[user.current_state.to_sym]
  end

  def set_company_name(company_name)
    if company_name.present?
    benchkiller_user = ::Benchkiller::User.find_by bot_telegram_user_id: user.id
    unless benchkiller_user.present?
      benchkiller_user = ::Benchkiller::User.create! bot_telegram_user_id: user.id,
        project_id: BotTelegram::BenchkillerBot::PROJECT_ID
    end
    company = benchkiller_user.companies.first
    if company.present?
      old_company_name = company.title
      if company.update title: company_name
        message_to_chat bot, chat, "Ваша компания #{old_company_name} переименована в #{company_name} на сервисе Benchkiller"
      else
        message_to_chat bot, chat, "К сожалению, ваша компания не переименована. Обратитесь в поддержку сервиса Benchkiller"
      end
    else
      company = ::Benchkiller::Company.create! title: company_name,
        project_id: BotTelegram::BenchkillerBot::PROJECT_ID
      company.companies_users.create! user_id: benchkiller_user.id
      message_to_chat bot, chat, "Ваша компания #{company_name} успешно создана на Benchkiller"
    end
    else
      message_to_chat bot, chat, "Вам следует ввести название компании"
    end
  end
end
