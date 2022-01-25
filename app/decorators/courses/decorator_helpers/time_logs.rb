module Courses::DecoratorHelpers::TimeLogs
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
          TimeLog.logged_by(user, object)
        end)
      end
    end)
  end

  private

  def users_logged_time
    Tramway::User::User.where(id: object.time_logs.map(&:user_id).uniq)
  end
end
