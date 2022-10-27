module BotTelegram::FindMedsBot::Actions::LastStep
  def last_step(answer)
    case answer
    when 'Бот мне помог!'
      user.set_finished_state_for bot: bot_record
      answer = i18n_scope(:find_medicine, :congratulations)
      show options: [['В начало']], answer: answer
    when 'Это не совсем та информация, на которую я надеялся_ась (отправить отзыв)'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :please_type_info_about_medicine)
      show options: [['В начало']], answer: answer
    end
  end
end
