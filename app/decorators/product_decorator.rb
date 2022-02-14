class ProductDecorator < ApplicationDecorator
  delegate_attributes :title, :tech_name

  decorate_association :tasks

  include Concerns::TimeLogsTable

  class << self
    def collections
      [ :all ]
    end

    def list_attributes
      [ :time_logs ]
    end

    def show_attributes
      [ :tech_name, :time_logs ]
    end

    def show_associations
      [ :tasks ]
    end
  end

  def everyday_report(date)
    report = object.time_logs.where(created_at: date.all_day).group_by(&:associated).reduce('') do |text, (task, time_logs)|
      text += "📌 #{task.title}\n"
      time_logs.each do |time_log|
        text += "  • #{time_log.user.first_name} #{time_log.user.last_name}: #{time_log.comment}\n"
      end
      text += "\n"
    end.gsub('*', '')
    intro = "🪄  *Отчёт за #{date.strftime('%d.%m.%Y')}*\n\n"
    intro + (report.present? ? report : 'Вчера не было залогированных задач')
  end
end
