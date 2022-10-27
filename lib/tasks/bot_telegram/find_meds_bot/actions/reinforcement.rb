# frozen_string_literal: true

module BotTelegram::FindMedsBot::Actions::Reinforcement
  def reinforcement(answer)
    case answer
    when 'Да'
      medicine = current_state.data['medicine']
      medicines = ::FindMeds::Tables::Medicine.where(
        'concentrations' => medicine['fields']['concentrations'],
        'form' => medicine['fields']['form']
      )
      set_next_action :last_step
      list = medicines.map do |m|
        "🔵 #{m.name}"
      end.join("\n")
      answer = i18n_scope(:find_medicine, :result_message, list: list)
      show options: [['Бот мне помог!'], ['Это не совсем та информация, на которую я надеялся_ась (отправить отзыв)']],
        answer: answer
    when 'Нет'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :unfortunately_we_do_not_have_more_info)
      show options: [['В начало']], answer: answer
    end
  end
end
