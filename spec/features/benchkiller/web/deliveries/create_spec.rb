# frozen_string_literal: true

require 'rails_helper'

describe 'Create Benchkiller deliveries', type: :feature do
  before { move_host_to benchkiller_host }

  let!(:offers) do
    tag = Benchkiller::Tag.find_by(title: :lookfor) || create(:benchkiller_lookfor_tag)
    create_list :benchkiller_offer, 10, tags: [tag]
  end

  let!(:user) do
    create :benchkiller_user, password: '123456'
  end

  let(:attributes) do
    attributes_for :benchkiller_delivery
  end

  before do
    visit '/'

    fill_in 'bot_telegram_user[username]', with: user.username
    fill_in 'bot_telegram_user[password]', with: '123456'

    click_on 'Войти'

    offers.each(&:reload)
    offers.each do |offer|
      click_on_check_box_by_id offer.uuid
    end

    sleep 1
    find('a', text: 'Сделать рассылку', match: :first).click

    fill_in 'benchkiller_delivery[text]', with: attributes[:text]
    click_on 'Посмотреть'

    click_on 'Начать рассылку'
  end

  describe 'for user without company' do
    it 'checks text' do
      delivery = Benchkiller::Delivery.last

      final_text = benchkiller_i18n_scope(:deliveries, :template, username: user.username, text: attributes[:text])

      expect(Benchkiller::DeliveryWorker).to have_enqueued_sidekiq_job(delivery.receivers.map(&:id), final_text)
    end
  end

  describe 'for user with company' do
    before do
      create :benchkiller_company, users: [user]
    end

    it 'checks text' do
      delivery = Benchkiller::Delivery.last

      final_text = benchkiller_i18n_scope :deliveries, :template,
        username: user.username,
        text: attributes[:text],
        company: "и #{user.company.title}"

      expect(Benchkiller::DeliveryWorker).to have_enqueued_sidekiq_job(delivery.receivers.map(&:id), final_text)
    end
  end
end
