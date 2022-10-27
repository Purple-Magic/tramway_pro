# frozen_string_literal: true

module BotTelegram::FindMedsBot::Actions::FindMedicine
  def find_medicine(name)
    drug = ::BotTelegram::FindMedsBot::Tables::Drug.find_by('Name' => name)
    if drug.present?
      companies = drug.medicines.map do |medicine|
        medicine.company.name
      end.uniq

      set_next_action :choose_company, medicines: drug.medicines
      answer = i18n_scope(:find_medicine, :found)
      show options: [companies, ['В начало', 'Нужного производителя нет']], answer: answer
    else
      set_next_action :saving_feedback, medicine_name: name
      answer = i18n_scope(:find_medicine, :not_found)
      show options: [['В начало']], answer: answer
    end
  end
end
