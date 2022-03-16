module AuditsLocales
  def localize_changes(audit)
    audit.audited_changes.map do |(attribute, transition)|
      model_class = audit.auditable.class
      attribute_name = model_class.human_attribute_name(attribute)
      changes = if transition.first.is_a? Hash
                  localize_json_diff model_class, transition.first, transition.last
                else
                  {
                    old: transition.first,
                    new: transition.last
                  }
                end
      "#{attribute_name}\n\nСтарое значение:\n#{changes[:old]}\n\nНовое значение:\n#{changes[:new]}"
    end
  end

  def localize_json_diff(model_class, old, new)
    diff = hash_diff old, new

    {
      old: diff.map do |(key, _)|
        "#{model_class.human_attribute_name(key)} => #{old[key]}"
      end.join("\n"),
      new: diff.map do |(key, value)|
        "#{model_class.human_attribute_name(key)} => #{value}"
      end.join("\n")
    }
  end

  def hash_diff(old, new)
    new.reject { |k, v| old[k] == v }.merge(old.reject { |k, v| new.has_key?(k) })
  end
end
