# frozen_string_literal: true

module LongTestStuff
  def command(name:, **options)
    description = YAML.load_file("#{Rails.root}/spec/support/podcast_engine/commands.yml").with_indifferent_access[name]
    options.reduce(description) do |result_command, (key, value)|
      result_command.gsub!("%{#{key}}", value)
    end
  end
end
