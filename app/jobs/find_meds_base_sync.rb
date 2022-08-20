require_relative '../../lib/tasks/bot_telegram/find_meds_bot/tables/company'
require_relative '../../lib/tasks/bot_telegram/find_meds_bot/tables/component'
require_relative '../../lib/tasks/bot_telegram/find_meds_bot/tables/concetration'
require_relative '../../lib/tasks/bot_telegram/find_meds_bot/tables/drug'
require_relative '../../lib/tasks/bot_telegram/find_meds_bot/tables/medicine'

class FindMedsBaseSync < ActiveJob::Base
  queue_as :find_meds

  def perform(*_args)
    entities = [ :drug, :company, :component ]
    entities.each do |entity|
      sync_entity entity.to_s
    end
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end

  private

  def sync_entity(name)
    airtable_entity = "BotTelegram::FindMedsBot::Tables::#{name.camelize}".constantize
    rails_entity = "FindMeds::#{name.camelize}".constantize
    instances = airtable_entity.all
    instances.each do |instance|
      saved_instance = rails_entity.find_by airtable_id: instance.id
      attributes = instance.fields.reduce({}) do |hash, (key, value)|
        attribute = "#{rails_entity}::ATTRIBUTES".constantize.invert[key]

        if attribute.present?
          values_constant_name = "#{rails_entity}::#{attribute.upcase}_VALUES" 
          value = if Object.const_defined?(values_constant_name)
                    values_constant_name.constantize[value]
                  else
                    value
                  end

          hash.merge! attribute => value
        else
          hash
        end
      end.merge airtable_id: instance.id

      if saved_instance.present?
        saved_instance.update! attributes
      else
        rails_entity.create! attributes
      end
    end

    rails_entity.where.not(airtable_id: instances.map(&:id)).each &:destroy
  end

  def sync_concentration
  end
end
