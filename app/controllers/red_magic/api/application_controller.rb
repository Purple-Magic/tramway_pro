# frozen_string_literal: true

class RedMagic::Api::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session
end
