# frozen_string_literal: true

class TimeLogXlsDecorator < Tramway::Export::Xls::ApplicationDecorator
  delegate_attributes :time_spent, :comment

  class << self
    def columns
      %i[username task_name time_spent comment].map do |column|
        { TimeLog.human_attribute_name(column) => column }
      end
    end

    def filename
      'time_logs.xls'
    end

    def sheet_name
      'Отчёт по времени'
    end
  end

  def username
    "#{object.user.first_name} #{object.user.last_name}"
  end

  def task_name
    object.associated.title
  end
end
