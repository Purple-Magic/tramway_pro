module BotTelegram::FindMedsBot::Actions::ChooseForm
  def choose_form(form)
    if form == 'Нужной формы нет'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :form_not_found)
      show options: [['В начало']], answer: answer
    else
      medicines = current_state.data['medicines'].select do |medicine|
        medicine['fields']['form'].include? form
      end
      concentrations_ids = medicines.map do |medicine|
        medicine['fields']['concentrations']
      end.flatten.uniq

      concentrations = ::BotTelegram::FindMedsBot::Tables::Concentration.where('id' => concentrations_ids)
      components = ::BotTelegram::FindMedsBot::Tables::Component.where('id' => concentrations.map(&:link_to_active_components).flatten)

      if components.count > 1
        set_next_action :saving_feedback
        answer = 'У этого лекарства более одного действующего вещества, пока что бот не умеет работать с такими лекарствами. Напишите комментарий в свободной форме, что вы хотели найти.'
        show options: [['В начало']], answer: answer
      elsif components.count == 1
        set_next_action :choose_concentration, medicines: medicines, concentrations: concentrations
        answer = i18n_scope(:find_medicine, :what_concentration, component: components.first.name)
        buttons_collection = concentrations.each_slice(4).map do |concentration|
          concentration.map(&:value)
        end
        show options: [*buttons_collection, ['В начало', 'Нужной концентрации нет']], answer: answer
      elsif components.count.zero?
        send_message_to_user 'Кажется, у нас ошибка в базе данных'
      end
    end
  end
end
