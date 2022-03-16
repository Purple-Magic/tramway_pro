module AuditsLocales
  def localize_changes(audit)
    audit.audited_changes.map do |(attribute, transition)|
      "#{audit.auditable.class.human_attribute_name(attribute)}\n\nСтарое значение:\n#{transition.first}\n\nНовое значение:\n#{transition.last}"
    end
  end
end
