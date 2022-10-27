# frozen_string_literal: true

module BotTelegram::FindMedsBot::Actions::ChooseCompany
  def choose_company(name)
    if name == 'Нужного производителя нет'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :company_not_found)
      show options: [['В начало']], answer: answer
    else
      company = ::FindMeds::Tables::Company.find_by('Name' => name)
      medicines = current_state.data['medicines'].select do |medicine|
        medicine['fields']['link_to_company'].include? company.id
      end
      forms = medicines.map do |medicine|
        medicine['fields']['form']
      end.flatten.uniq

      if forms.any?
        set_next_action :choose_form, medicines: medicines
        answer = i18n_scope(:find_medicine, :what_form)
        show options: [forms, ['В начало', 'Нужной формы нет']], answer: answer
      else
        set_next_action :saving_feedback
        answer = i18n_scope(:find_medicine, :we_dont_have_forms)
        show options: [['В начало']], answer: answer
      end
    end
  end
end