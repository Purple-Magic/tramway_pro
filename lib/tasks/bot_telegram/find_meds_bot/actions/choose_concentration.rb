# frozen_string_literal: true

module BotTelegram::FindMedsBot::Actions::ChooseConcentration
  def choose_concentration(value)
    if value == 'Нужной концентрации нет'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :concentration_not_found)
      show options: [['В начало']], answer: answer
    else
      medicines = current_state.data['medicines'].select do |medicine|
        medicine['fields']['concentrations'].include? chosen_concentration(value).id
      end
      if medicines.count == 1
        medicine = medicines.first
        set_next_action :reinforcement, medicine: medicine
        answer = i18n_scope(:find_medicine, :this_medicine, medicine: medicine['fields']['Name'])
        show options: [%w[Да Нет]], answer: answer
      end
    end
  end

  private

  def chosen_concentration(value)
    concentrations_ids = current_state.data['concentrations'].map { |conc| conc['id'] }
    concentrations = ::FindMeds::Tables::Concentration.where('id' => concentrations_ids)
    concentrations.select do |concentration|
      concentration.value == value
    end.first
  end
end
