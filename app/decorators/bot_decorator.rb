# frozen_string_literal: true

class BotDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :name, :team, :finished_users

  decorate_association :steps

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
    link_to "@#{object.slug}", "https://t.me/#{object.slug}", target: '_blank' if object.slug.present?
  end

  def options
    yaml_view object.options
  end

  def scenario
    content_tag(:table) do
      concat(content_tag(:thead)) do
        concat(content_tag(:th)) do
          concat BotTelegram::Scenario::Step.human_attribute_name(:name)
        end
        concat(content_tag(:th)) do
          concat BotTelegram::Scenario::Step.human_attribute_name(:links)
        end
      end
      steps.each do |st|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            concat st.name
          end)
          concat(content_tag(:td) do
            concat st.links
          end)
        end)
      end
    end
  end

  def stats
    content_tag(:table) do
      concat(content_tag(:thead) do
        concat(content_tag(:th) do
          concat BotTelegram::Scenario::Step.human_attribute_name(:text)
        end)
        concat(content_tag(:th) do
          concat BotTelegram::Scenario::Step.human_attribute_name(:progress_records_count)
        end)
      end)
      object.steps.active.each do |st|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            concat st.text
          end)
          concat(content_tag(:td) do
            concat st.progress_records.count
          end)
        end)
      end
    end
  end

  def users_count
    if object.custom
      object.messages.map(&:user).flatten.uniq.count
    else
      object.users.uniq.count
    end
  end

  def users_finished
    if object.team.night?
      finished_users.count
    else
      'N/A'
    end
  end

  def messages_count
    object.custom ? object.messages.count : object.progress_records.uniq.count
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
