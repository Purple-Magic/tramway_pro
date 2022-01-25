require 'rails_helper'

describe 'Products' do
  before do
    host! red_magic_host
    create :product, title: 'Benchkiller'
  end

  describe 'API' do
    describe 'Tasks' do
      it 'creates new task' do
        count = Products::Task.count

        json = {
          data: {
            attributes: {
              title: "cardname",
              product: 'Benchkiller'
            }
          }
        }
        post '/api/v1/records?model=Products::Task', params: json

        expect(Products::Task.count).to eq count + 1
      end
    end
  end
end
