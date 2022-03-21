# frozen_string_literal: true

require_relative 'notify'

module BotTelegram::BenchkillerBot::AdminFeatures
  include ::BotTelegram::BenchkillerBot::Notify
  include AuditsLocales
  include ::BotTelegram::BenchkillerBot::Concern

  def send_approve_message_to_admin_chat(offer)
    return unless offer.available? || offer.lookfor?

    if offer.benchkiller_user&.company&.approved?
      offer.send_to_public_channel
    else
      text = ::Benchkiller::Offers::AdminChatDecorator.decorate(offer).admin_message
      keyboard = [
        [
          ['Подтвердить', { data: { command: :approve_offer, argument: offer.id } }],
          ['Отклонить', { data: { command: :decline_offer, argument: offer.id } }]
        ]
      ]
      message = ::BotTelegram::Custom::Message.new text: text, inline_keyboard: keyboard
      send_notification_to_chat ::BotTelegram::BenchkillerBot::ADMIN_CHAT_ID, message
    end
  end

  def send_companies_changes_to_admin_chat(company)
    last_audit = company.audits.last
    return unless last_audit.audited_changes.keys.include? 'data'

    data_changes = hash_diff(
      (last_audit.audited_changes['data']&.first || {}),
      (last_audit.audited_changes['data']&.last || {}),
    )

    return unless (data_changes.keys & [ 'regions_to_cooperate', 'place' ]).any?

    text = i18n_scope(
      :admin,
      :company_changes,
      company_name: company.title,
      changes: localize_changes(last_audit).join("\n"),
      url: Tramway::Admin::Engine.routes.url_helpers.edit_record_url(company, model: company.class, host: Settings[Rails.env][:purple_magic])
    )
    send_notification_to_chat ::BotTelegram::BenchkillerBot::ADMIN_COMPANIES_CHAT_ID, text
  end

  def send_companies_creating_to_admin_chat(company)
    text = i18n_scope(
      :admin,
      :company_creates,
      company_name: company.title
    )
    send_notification_to_chat ::BotTelegram::BenchkillerBot::ADMIN_COMPANIES_CHAT_ID, text
  end

  def approve_offer(argument)
    offer = ::Benchkiller::Offer.find argument
    offer.approve
  end

  def decline_offer(argument)
    offer = ::Benchkiller::Offer.find argument
    offer.decline
    offer.save!
  end
end
