# frozen_string_literal: true

class PodcastDecorator < ApplicationDecorator
  delegate_attributes :title, :footer, :youtube_footer

  decorate_associations :stars, :musics, :episodes, :stats

  alias name title

  include Concerns::TimeLogsTable

  class << self
    def show_associations
      %i[stars musics episodes stats]
    end

    def show_attributes
      %i[time_logs_table stats_table]
    end
  end

  def stats_table
    monthes = object.stats.group(:month, :year).count :id
    grouped_numbers = {
      downloads: object.stats.group(:month, :year).sum(:downloads),
      streams: object.stats.group(:month, :year).sum(:streams),
      listeners: object.stats.group(:month, :year).sum(:listeners),
      hours: object.stats.group(:month, :year).sum(:hours),
      average_listenning: object.stats.group(:month, :year).sum(:average_listenning),
      overhearing_percent: object.stats.group(:month, :year).sum(:overhearing_percent)
    }

    table do
      monthes.each do |(month, _)|
        concat(tr do
          concat(td do
            month.join('.')
          end)
          concat(td do
            table do
              grouped_numbers.each do |(name, numbers)|
                concat(tr do
                  concat(td do
                    Podcast::Stat.human_attribute_name name
                  end)
                  concat(td do
                    raw numbers[month]
                  end)
                  concat(td do
                    services = object.stats.where(month: month.first,
                      year: month.last).where.not(name => nil).pluck(:service).map(&:camelize)
                    services.join(', ')
                  end)
                end)
              end
            end
          end)
        end)
      end
    end
  end
end
