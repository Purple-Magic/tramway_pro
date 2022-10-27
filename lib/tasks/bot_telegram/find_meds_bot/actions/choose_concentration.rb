# frozen_string_literal: true

module BotTelegram::FindMedsBot::Actions::ChooseConcentration
  def choose_concentration(value)
    if value == 'Нужной концентрации нет'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :concentration_not_found)
      show options: [['В начало']], answer: answer
    else
      concentrations_ids = current_state.data['concentrations'].map { |c| c['id'] }
      concentrations = ::BotTelegram::FindMedsBot::Tables::Concentration.where('id' => concentrations_ids)
      concentration = concentrations.select do |concentration|
        concentration.value == value
      end.first
      medicines = current_state.data['medicines'].select do |medicine|
        medicine['fields']['concentrations'].include? concentration.id
      end
      if medicines.count == 1
        medicine = medicines.first
        set_next_action :reinforcement, medicine: medicine
        answer = i18n_scope(:find_medicine, :this_medicine, medicine: medicine['fields']['Name'])
        show options: [%w[Да Нет]], answer: answer
      end
    end
  end
end
