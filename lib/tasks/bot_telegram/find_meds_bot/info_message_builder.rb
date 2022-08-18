# frozen_string_literal: true

class BotTelegram::FindMedsBot::InfoMessageBuilder
  include BotTelegram::FindMedsBot::Concern

  attr_reader :medicine, :company_name

  def initialize(medicine, company_name:)
    @medicine = medicine
    @company_name = company_name
  end

  def build
    alternative = "#{medicine['Название']} #{medicine['intersection_and_substance'].join(', ')} #{medicine['form'].join(', ')} #{company_name}"
    i18n_scope(:alternative, :we_know_about,
      alternative: alternative) + i18n_scope(:alternative, :we_dont_know_where_is_medicine)
  end
end
