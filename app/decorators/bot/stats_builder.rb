# frozen_string_literal: true

module Bot::StatsBuilder
  def stats_header
    concat(content_tag(:thead) do
      concat(content_tag(:th) do
        concat BotTelegram::Scenario::Step.human_attribute_name(:text)
      end)
      concat(content_tag(:th) do
        concat BotTelegram::Scenario::Step.human_attribute_name(:progress_records_count)
      end)
    end)
  end

  def stats_steps_rows
    object.steps.each do |st|
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
