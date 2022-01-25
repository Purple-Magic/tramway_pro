# frozen_string_literal: true

class Benchkiller::OfferSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :uuid, :title, :text, :created_at

  has_many :tags, serializer: ::Benchkiller::TagSerializer

  def title
    user = object.message.user
    user_title = "#{user.username.present? ? user.username : 'No username'}: #{user.first_name} #{user.last_name}"
    user_title
  end

  def text
    object.message.text
  end
end
