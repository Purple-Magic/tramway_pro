# frozen_string_literal: true

require 'telegram/bot'

token = '1371991341:AAHhClt1XF-OFJPQN1gIFlWUeDMHaVste-g'

def user_from(message)
  user = BotTelegram::User.find_or_create_by! username: message.from.username
  user.update! first_name: message.from.first_name,
    last_name: message.from.last_name,
    options: {
      can_join_groups: message.from.can_join_groups,
      can_read_all_group_messages: message.from.can_read_all_group_messages,
      language_code: message.from.language_code,
      supports_inline_queries: message.from.supports_inline_queries,
      is_bot: message.from.is_bot
    }
  user.reload
end

def chat_from(message)
  chat = BotTelegram::Chat.find_or_create_by! telegram_id: message.chat.id
  chat.update! title: message.chat.title,
    chat_type: message.chat.type,
    options: ([
      :all_members_are_administrators, :can_set_sticker_set, :description, :first_name, :invite_link,
      :last_name, :permissions, :photo, :pinned_message, :slow_mode_delay, :sticker_set_name,
      :username
    ].reduce({}) do |hash, attribute|
      hash.merge! attribute => message.chat.send(attribute)
    end)
  chat.reload
end

def log_message(message, user, chat)
  BotTelegram::Message.create! text: message.text, user_id: user.id, chat_id: chat.id,
    options: ([ :animation, :audio, :author_signature, :caption, :caption_entities, :channel_chat_created,
               :connected_website, :contact, :caption_entities, :channel_chat_created, :connected_website,
               :contact, :date, :delete_chat_photo, :document, :edit_date, :forward_date, :forward_from,
               :forward_from_chat, :forward_from_message_id, :forward_sender_name, :forward_signature, :game,
               :group_chat_created, :invoice, :left_chat_member, :location, :media_group_id, :message_id,
               :migrate_from_chat_id, :migrate_to_chat_id, :new_chat_members, :new_chat_photo, :new_chat_title,
               :passport_data, :photo, :pinned_message, :poll, :reply_markup, :reply_to_message, :sticker,
               :successful_payment, :supergroup_chat_created, :venue, :video, :video_note, :voice].reduce({}) do |hash, attribute|
                 hash.merge! attribute => message.send(attribute)
               end)
end

def start_game(message, user)
  
end

areas = ['Ленинский', 'Засвияжский', 'Заволжский', 'Железнодорожный']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    user = user_from message
    chat = chat_from message
    log_message message, user, chat
    if message.text == '/start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Привет, выбери свой район!',
        reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: areas, one_time_keyboard: true)
      )
    end
    if message.text.in? areas
      game = ChatQuestUlsk::Game.find_by area: message.text, bot_telegram_user_id: user.id
      game&.reload
      if game.present? && game.started?
        bot.api.send_message(
          chat_id: message.chat.id,
          text: 'Вы уже начали игру в этом районе'
        )
      else
        ChatQuestUlsk::Game.create! bot_telegram_user_id: user.id, area: message.text
      end
    end
  end
end
