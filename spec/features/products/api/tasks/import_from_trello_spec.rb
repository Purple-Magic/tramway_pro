require 'rails_helper'

describe 'Products' do
  before do
    host! red_magic_host
    create :product, tech_name: 'benchkiller'
  end

  describe 'API' do
    describe 'Tasks' do
      describe 'Creating' do
        it 'creates new task' do
          count = Products::Task.count

          json = YAML.load_file("#{Rails.root}/docs/trello/butler/actions/product_engine/create_task.yml")
          post '/api/v1/records?model=Products::Task', params: json

          expect(response).to have_http_status(:success)
          expect(Products::Task.count).to eq count + 1
        end
      end

      describe 'Deleting' do
        let!(:task) { create :products_task }

        it 'deletes new task' do
          json = YAML.load_file("#{Rails.root}/docs/trello/butler/actions/product_engine/delete_task.yml")
          json['data']['attributes']['deleted_at'] = DateTime.now

          put "/api/v1/records/#{task.card_id}?model=Products::Task", params: json
          task.reload
          expect(task.deleted_at).not_to be_nil
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
