# frozen_string_literal: true

::Tramway::Api.auth_config = { user_model: 'Benchkiller::User', auth_attributes: ['bot_telegram_users.username'] }
