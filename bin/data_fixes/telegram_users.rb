BotTelegram::User.all.each_with_index do |user, index|
  if user.active?
    if user.telegram_id.present?
      users = BotTelegram::User.active.where(telegram_id: user.telegram_id)
      if users.count > 1
        users.each do |u|
          unless u.id == user.id
            u.messages.each do |message|
              message.update! user_id: user.id
            end
            u.progress_records.each do |record|
              record.update! bot_telegram_user_id: user.id
            end
            u.states.each do |state|
              state.update! user_id: user.id
            end
            u.destroy
          end
        end
      end
      print "#{index} of #{BotTelegram::User.count}; Users count #{users.count}\r"
    else
      if user.username.present?
        users = BotTelegram::User.active.where(username: user.username)
        if users.count > 1
          current_user = users.select { |u| u.telegram_id.present? }.first
          users.each do |u|
            unless u.id == current_user.id
              u.messages.each do |message|
                message.update! user_id: current_user.id
              end
              u.progress_records.each do |record|
                record.update! bot_telegram_user_id: current_user.id
              end
              u.states.each do |state|
                state.update! user_id: current_user.id
              end
              u.destroy
            end
          end
        end
        print "#{index} of #{BotTelegram::User.count}; Users count #{users.count}\r"
      end
    end
    print "#{index} of #{BotTelegram::User.count}\r"
  end
end
