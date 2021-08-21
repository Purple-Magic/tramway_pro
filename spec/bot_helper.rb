require 'rails_helper'

module BotHelper
  def prepare_database
    tables = [
      :bots,
      :bot_telegram_scenario_steps,
      :projects
    ]
    username = ENV['USERNAME']
    at = Time.now.strftime('%Y-%m-%d--%H-%M')
    dump = "public-data--#{at}.dump"
    system "scp #{username}@138.68.76.45:/srv/tramway_pro/shared/config/database.yml ./"
    db_config = YAML.load_file('database.yml')
    db_name = db_config['production']['database']
    system 'rm -rf database.yml'
    command = "ssh -t #{username}@138.68.76.45 'pg_dump --column-inserts -a #{tables.map { |table| "-t #{table} " }.join} -Fc --no-acl --no-owner -v #{db_name} > #{dump}'"
    system "scp #{username}@138.68.76.45:#{dump} /tmp/"
    system command
    database_name = Rails.configuration.database_configuration["test"]["database"]
    system "pg_restore -d #{database_name} /tmp/#{dump}"
  end
end

include BotHelper
