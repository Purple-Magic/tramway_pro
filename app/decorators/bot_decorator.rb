# frozen_string_literal: true

class BotDecorator < ApplicationDecorator
  delegate_attributes :name, :team, :finished_users, :slug, :custom

  decorate_association :scenario_steps

  class << self
    def list_attributes
      %i[users_count link users_finished messages_count custom]
    end

    def show_attributes
      %i[name team link options users_count messages messages_count users_finished scenario stats]
    end

    def show_associations
      [:steps]
    end
  end

  def link
    link_to "@#{slug}", "https://t.me/#{slug}", target: '_blank' if slug.present?
  end

  def options
    yaml_view object.options
  end

  include Bot::ScenarioBuilder

  def scenario
    content_tag(:table) do
      scenario_header
      scenario_steps_rows
    end
  end

  include Bot::StatsBuilder

  def stats
    content_tag(:table) do
      stats_header
      stats_steps_rows
    end
  end

  def users_count
    link_to object.users.distinct.count,
      Tramway::Admin::Engine.routes.url_helpers.records_path(model: 'BotTelegram::User',
        filter: { bots_id_eq: object.id })
  end

  def users_finished
    object.team.night? ? finished_users.count : 'N/A'
  end

  def messages_count
    custom ? object.messages.count : object.progress_records.uniq.count
  end

  def messages
    filter = { bot_id_eq: object.id }
    href = Tramway::Admin::Engine.routes.url_helpers.records_path(model: ::BotTelegram::Message, filter: filter)
    content_tag :a, href: href do
      I18n.t('helpers.links.open')
    end
  end

  def custom
    object.custom ? I18n.t('helpers.yes') : I18n.t('helpers.no')
  end

  def additional_buttons
    add_scenario_step_url = Tramway::Admin::Engine.routes.url_helpers.new_record_path(
      model: 'BotTelegram::Scenario::Step',
      'bot_telegram/scenario/step' => { bot: object.id }, redirect: "/admin/records/#{object.id}?model=Bot"
    )

    { show: [{ url: add_scenario_step_url, inner: -> { fa_icon :plus }, color: :success }] }
  end
end
