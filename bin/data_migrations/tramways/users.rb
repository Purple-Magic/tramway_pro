require "#{Rails.root}/lib/middleware/multi_project_configuration_middleware/user"

Tramway::User.delete_all

::Admin::Tramway::UserForm.include MultiProjectCallbacks::UserForm
::Tramway::User.include MultiProjectCallbacks::UserCallbacks

users = ActiveRecord::Base.connection.execute "SELECT * FROM tramway_user_users"
users.sort { |u| u['id'] }.each_with_index do |user, index|
  begin
    user['state'] = 'removed' if user['state'] == 'remove'
    new_record = Tramway::User.create! user.except 'id'
    audits = Audited::Audit.where auditable_type: 'Tramway::User::User', auditable_id: user['id']
    audits.each do |audit|
      audit.update! auditable_type: 'Tramway::User', auditable_id: new_record.id
    end
    time_logs = TimeLog.where user_id: user['id']
    time_logs.each do |time_log|
      time_log.update! user_id: new_record.id
    end
    print "#{index} of #{users.count}\r"
  rescue StandardError => e
    binding.pry
  end
end
