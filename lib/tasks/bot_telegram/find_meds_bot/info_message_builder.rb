# frozen_string_literal: true

class BotTelegram::FindMedsBot::InfoMessageBuilder
  include BotTelegram::FindMedsBot::Concern

  attr_reader :medicine, :company_name, :components

  def initialize(medicine, company_name:, components:)
    @medicine = medicine
    @company_name = company_name
    @components = components
  end

  def build
    alternative = "#{medicine['Name']} #{components.join(', ')} #{medicine['form'].join(', ')} #{company_name}"
    i18n_scope(:alternative, :we_know_about,
      alternative: alternative) + i18n_scope(:alternative, :we_dont_know_where_is_medicine)
  end
end
