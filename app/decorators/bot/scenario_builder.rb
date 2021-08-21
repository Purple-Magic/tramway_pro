# frozen_string_literal: true

module Bot::ScenarioBuilder
  def scenario_header
    concat(content_tag(:thead)) do
      concat(content_tag(:th)) do
        concat BotTelegram::Scenario::Step.human_attribute_name(:name)
      end
      concat(content_tag(:th)) do
        concat BotTelegram::Scenario::Step.human_attribute_name(:links)
      end
    end
  end

  def scenario_steps_rows
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
