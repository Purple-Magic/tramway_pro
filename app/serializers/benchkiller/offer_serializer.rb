# frozen_string_literal: true

class Benchkiller::OfferSerializer < ApplicationSerializer
  attributes :uuid, :title, :text, :created_at, :username

  has_many :tags, serializer: ::Benchkiller::TagSerializer

  def title
    user = object.message.user
    "#{user.username.present? ? user.username : 'No username'}: #{user.first_name} #{user.last_name}"
  end

  def text
    object.message.text
  end

  def username
    object.message.user.username
  end
end
