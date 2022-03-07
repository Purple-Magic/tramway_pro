# frozen_string_literal: true

module LongTestStuff
  def command(name:, **options)
    description = YAML.load_file("#{Rails.root}/spec/support/podcast_engine/commands.yml").with_indifferent_access[name]
    options.reduce(description) do |result_command, (key, value)|
      result_command.gsub!("%{#{key}}", value)
    end
  end

  def ssh_run(connect_info, command)
    "ssh #{connect_info} \"#{command}\""
  end

  def scp_run(file, connect_info, path)
    "scp #{file} #{connect_info}:#{path}"
  end
end
