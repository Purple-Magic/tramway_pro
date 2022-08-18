# frozen_string_literal: true

class Product::TasksXlsDecorator < Tramway::Export::Xls::ApplicationDecorator
  delegate_attributes :title

  class << self
    def filename
      'tasks.xls'
    end

    def sheet_name
      'Отчёт по задачам'
    end
  end

  include TimeManager

  def flexible_columns
    [{ title: -> { object.title } }] + object.product.time_logs.map(&:user).flatten.map do |user|
      { user.full_name => -> { TimeLog.time_logged_by(user, object) } }
    end + [{ sum: -> { minutes_to_hours(object.time_logs.sum { |t| t.minutes_of(t.time_spent) }) } }]
  end
end
