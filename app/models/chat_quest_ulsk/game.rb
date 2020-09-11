class ChatQuestUlsk::Game < ApplicationRecord
  belongs_to :user, class_name: 'BotTelegram::User', foreign_key: :bot_telegram_user_id

  def finished_at
    audits.find_by(action: :update, audited_changes: { 'game_state' => [ 'started', 'finished' ] })&.created_at
  end

  def messages
    user_messages = user.messages.where('created_at > ? AND created_at < ?', created_at, finished_at || DateTime.now)
    events = audits.map do |audit|
      audit if audit.audited_changes['current_position'].present?
    end.compact
    sorted_collection = (events + user_messages).sort_by { |obj| obj&.created_at }
    sorted_collection.map do |obj|
      case obj.class.to_s
      when 'Audited::Audit'
        case obj.action
        when 'create'
          ChatQuestUlsk::Message.find_by(quest: quest, position: 1)
        when 'update'
          ChatQuestUlsk::Message.find_by(quest: quest, position: obj.audited_changes['current_position'][1])
        end
      when 'BotTelegram::Message'
        obj
      end
    end.compact
  end

  state_machine :game_state, initial: :started do
    state :started
    state :finished

    event :finish do
      transition started: :finished
    end
  end

  search_by :quest, user: [ :first_name, :username, :last_name ]
end
