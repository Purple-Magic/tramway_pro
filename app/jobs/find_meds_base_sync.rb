require_relative '../../lib/tasks/bot_telegram/find_meds_bot/tables/company'
require_relative '../../lib/tasks/bot_telegram/find_meds_bot/tables/component'
require_relative '../../lib/tasks/bot_telegram/find_meds_bot/tables/concetration'
require_relative '../../lib/tasks/bot_telegram/find_meds_bot/tables/drug'
require_relative '../../lib/tasks/bot_telegram/find_meds_bot/tables/medicine'

class FindMedsBaseSync < ActiveJob::Base
  queue_as :find_meds

  def perform(*_args)
    sync_drugs
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end

  private

  def sync_drugs
    drugs = BotTelegram::FindMedsBot::Tables::Drug.all
    drugs.each do |drug|
      saved_drug = FindMeds::Drug.find_by airtable_id: drug.id
      attributes = drug.fields.reduce({}) do |hash, (key, value)|
        attribute = FindMeds::Drug::ATTRIBUTES.invert[key]

        if attribute.present?
          value = case attribute
                  when :patent
                    FindMeds::Drug::PATENT_VALUES[value]
                  else
                    value
                  end

          hash.merge! attribute => value
        else
          hash
        end
      end.merge airtable_id: drug.id
      if saved_drug.present?
        saved_drug.update! attributes
      else
        FindMeds::Drug.create! attributes
      end
    end

    FindMeds::Drug.where.not(airtable_id: drugs.map(&:id)).each &:destroy
  end
end
