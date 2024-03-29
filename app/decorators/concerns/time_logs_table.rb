# frozen_string_literal: true

module TimeLogsTable
  include TableBuilder

  def time_logs_table
    table do
      time_logs_table_header
      time_logs_table_body
    end
  end

  def time_logs_table_header
    users_logged_time.each do |user|
      concat(th do
        "#{user.first_name} #{user.last_name}"
      end)
    end
  end

  def time_logs_table_body
    concat(tr do
      users_logged_time.each do |user|
        concat(td do
          TimeLog.time_logged_by(user, object)
        end)
      end
    end)
  end

  def time_logs_list
    table do
      object.time_logs.order(:id).each do |time_log|
        concat(tr do
          concat(td do
            time_log.user.full_name
          end)
          concat(td do
            time_log.time_spent
          end)
          concat(td do
            time_log.comment
          end)
        end)
      end
    end
  end

  private

  def users_logged_time(begin_date: nil, end_date: nil)
    collection = object.time_logs
    collection = collection.where(created_at: begin_date..end_date) if begin_date.present? && end_date.present?
    Tramway::User.where(id: collection.map(&:user_id).uniq)
  end
end
