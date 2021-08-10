# frozen_string_literal: true

class BotDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :name, :team, :finished_users

  decorate_association :steps

  class << self
    def list_attributes
      %i[users_count link users_finished messages_count custom]
    end

    def show_attributes
      %i[name team options users_count messages messages_count users_finished scenario stats]
    end

    def show_associations
      [:steps]
    end
  end

  def scenario
    content_tag(:div) do
      concat(javascript_include_tag('https://unpkg.com/gojs@2.1/release/go.js'))
      concat(content_tag(:div, id: :scenario, style: 'width: 500px; height: 200px') do
      end) 
      concat(content_tag(:script) do
        <<-JAVASCRIPT
        var goJS = go.GraphObject.make;

        var myDiagram = goJS(go.Diagram, `scenario`);
        myDiagram.nodeTemplate = goJS(go.Node, `Horizontal`, { background: `#44CCFF` },
          goJS(go.Picture, { margin: 10, width: 50, height: 50, background: `red` },
            new go.Binding(`source`)), goJS(go.TextBlock, `Default Text`,
            { margin: 12, stroke: `white`, font: `bold 16px sans-serif` },
            new go.Binding(`text`, `name`))
        );

        myDiagram.model = new go.Model([
          { key: `A` },
          { key: `B`, parent: `A` },
          { key: `C`, parent: `B` }
        ])
        JAVASCRIPT
      end)
    end
  end

  def link
    link_to "@#{object.slug}", "https://t.me/#{object.slug}", target: '_blank' if object.slug.present?
  end

  def options
    yaml_view object.options
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
    if object.custom
      object.messages.count
    else
      object.progress_records.uniq.count
    end
  end

  def messages
    filter = { bot_id_eq: object.id }
    href = Tramway::Admin::Engine.routes.url_helpers.records_path(model: ::BotTelegram::Message, filter: filter)
    content_tag :a, href: href do
      I18n.t('helpers.links.open')
    end
  end

  def custom
    if object.custom
      I18n.t('helpers.yes')
    else
      I18n.t('helpers.no')
    end
  end
end
