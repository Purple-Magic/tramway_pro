# frozen_string_literal: true

class ProductDecorator < ApplicationDecorator
  delegate_attributes :title, :tech_name

  decorate_association :tasks
  decorate_association :time_logs

  include Concerns::TimeLogsTable
  include TimeManager

  class << self
    def collections
      [:all]
    end

    def list_attributes
      [:time_logs_table]
    end

    def show_attributes
      %i[time_logs_table monthes_time_logs weeks_time_logs sum_estimation sum_time_logs]
    end

    def show_associations
      [:tasks]
    end
  end

  def sum_estimation
    minutes = tasks.sum { |t| t.object.minutes_of(t.estimation) }
    minutes_to_hours minutes
  end

  def sum_time_logs
    minutes = object.time_logs.sum { |t| t.minutes_of(t.time_spent) }
    minutes_to_hours minutes
  end

  def everyday_report(date)
    grouped_time_logs = object.time_logs.where(passed_at: date.all_day).group_by(&:associated)
    report = grouped_time_logs.reduce('') do |text, (task, time_logs)|
      text += "📌 #{task.title}\n"
      time_logs.each do |time_log|
        text += "  • #{time_log.user.first_name} #{time_log.user.last_name}: #{time_log.comment}\n"
      end
      text += "\n"
    end.gsub('*', '')
    intro = "🪄  *Отчёт за #{date.strftime('%d.%m.%Y')}*\n\n"
    intro + (report.present? ? report : 'Вчера не было залогированных задач')
  end

  def monthes_time_logs
    time_logs_by :month
  end

  def weeks_time_logs
    time_logs_by :week
  end

  private

  def time_logs_button_inner
    content_tag(:span) do
      concat(fa_icon('clock'))
      concat(' ')
      concat(fa_icon('file-excel'))
    end
  end

  def time_logs_by(period)
    begin_date = object.created_at.send "beginning_of_#{period}"
    end_date = object.created_at.send "end_of_#{period}"

    table do
      while begin_date < DateTime.now
        logged_users = users_logged_time(begin_date: begin_date, end_date: end_date)
        concat(tr(rowspan: logged_users.count) do
          concat(th do
            case period
            when :month
              begin_date.strftime('%B')
            when :week
              "#{begin_date.strftime('%d.%m')} - #{end_date.strftime('%d.%m')}"
            end
          end)
          if logged_users.any?
            logged_users.each do |user|
              time_logs_ids = TimeLog.logged_by(user, object, begin_date, end_date).map(&:id)
              filter = { id_in: time_logs_ids }
              url = Tramway::Admin::Engine.routes.url_helpers.records_path(model: ::TimeLog, filter: filter)

              concat(td do
                user.full_name
              end)
              concat(td do
                TimeLog.time_logged_by(user, object, begin_date, end_date)
              end)
              concat(td do
                link_to url, class: 'btn btn-success btn-sm' do
                  fa_icon 'file-excel'
                end
              end)
            end
          else
            concat(td do
              concat(content_tag(:span) do
                'Нет таймлогов'
              end)
            end)
          end
        end)
        begin_date = (begin_date + 1.send(period)).send "beginning_of_#{period}"
        end_date = (end_date + 1.send(period)).send "end_of_#{period}"
      end
    end
  end
end
