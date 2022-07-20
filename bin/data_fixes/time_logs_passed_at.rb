count = TimeLog.count

TimeLog.find_each.with_index do |time_log, index|
  unless time_log.comment.present?
    time_log.update! comment: :error
  end
  if time_log.associated.present? && time_log.user.present?
    time_log.update! passed_at: time_log.created_at
    print "#{index} of #{count}\r"
  else
    time_log.destroy
  end
end
