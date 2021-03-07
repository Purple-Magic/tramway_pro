# frozen_string_literal: true

FactoryBot.define do
  sequence :string, aliases: [:title] do |n|
    "string#{n}"
  end
  sequence :name do
    "name#{SecureRandom.hex(4)}"
  end
  sequence :address do |n|
    "street-#{n}"
  end
  sequence :short_string do |n|
    "str#{n}"
  end
  sequence :password do |n|
    "password#{n}"
  end
  sequence :integer do |n|
    n
  end
  sequence :email do
    "email_#{SecureRandom.hex(4)}@mail.com"
  end
  sequence :url do |n|
    "http://site#{n}.com"
  end
  sequence :date, aliases: [:time] do |n|
    Time.zone.today + n.day
  end
  sequence :colour do
    (1..6).reduce('') { |str| str + (('a'..'f').to_a + ('0'..'9').to_a).sample }
  end
  sequence :filename do |n|
    "file#{n}.png"
  end
  sequence :image_as_file do |_n|
    Rack::Test::UploadedFile.new(Rails.root.join('public/temp.png'), 'image/png')
  end
  sequence :full_hd_image_as_file do |_n|
    Rack::Test::UploadedFile.new(Rails.root.join('public/big-image.jpg'), 'jpg/jpeg')
  end
  sequence :full_hd_image_as_path do |_n|
    Rails.root.join('public/big-image.jpg')
  end
  sequence :image_as_base64 do |_n|
    Base64.encode64(File.open('public/temp.png', 'rb').read)
  end
  sequence :file_image do |_n|
    Rack::Test::UploadedFile.new(Rails.root.join('public/temp.png'), 'image/png')
  end
  sequence :latitude do |_n|
    rand(-90.0..90.0).round(5)
  end
  sequence :longtitude do |_n|
    rand(-180.0..180.0).round(5)
  end
  sequence :coordinates do
    "(#{rand(-90.0..90.0).round(5)},#{rand(-180.0..180.0).round(5)})"
  end
  sequence :phone do |n|
    "+#{447_123_456_780 + n}"
  end
  sequence :birthdate, aliases: [:start_date] do |_n|
    rand(10..100).year.ago
  end
  sequence :zipcode do |n|
    "#{"#{n}000"[0, 3]}AH"
  end
  sequence :file do
    Rack::Test::UploadedFile.new(Rails.root.join('public/1.pdf'), 'pdf')
  end
  sequence :xlsx do
    Rack::Test::UploadedFile.new(Rails.root.join('public/1.xlsx'), 'xlsx')
  end
  sequence :username do |n|
    "username#{n}"
  end
  sequence :quote do |n|
    (1_000 + n).to_s
  end
  sequence :postcode do |_n|
    'ab1 0aa'
  end
  sequence :float, aliases: [:fee] do |n|
    "0.#{n}".to_f
  end
end
