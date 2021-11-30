# frozen_string_literal: true

class Benchkiller::Auth::UserForm < Tramway::Core::ApplicationForm
  properties :username
  attr_accessor :password

  def validate(params)
    (!model.new_record? && model.authenticate(params[:password])).tap do |result|
      add_wrong_username_or_password_error unless result
    end
  end

  def need_to_generate_password?
    !model.password_digest.present?
  end

  private

  def add_wrong_username_or_password_error
    errors.add(:username, I18n.t('errors.wrong_username_or_password'))
  end
end
