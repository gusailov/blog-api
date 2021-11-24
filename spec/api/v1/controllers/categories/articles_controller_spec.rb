# TODO: remove this require, add it to .rspec
require 'rails_helper'

RSpec.describe Api::V1::Categories::ArticlesController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  describe '#index' do
    describe 'success' do
      let!(:article_1) { create(:article, user: user, category: category, created_at: Date.yesterday) }
      let!(:article_2) { create(:article, user: user, category: category, created_at: Date.today) }
      let(:created_article_count) { 2 }
      let(:params) do
        {
          category_id: category.id
        }
      end

      it 'returns Articles of specific category' do
        get :index, params: params, format: :json

        json_response = JSON.parse(response.body)

        article_category_ids = json_response['articles'].map { |a| a['category']['id'] }

        article_category_ids.each do |id|
          expect(id).to eq(category.id)
        end

        expect(response.content_type).to include 'application/json'
      end

      it 'returns list of Articles' do
        get :index, params: params, format: :json

        json_response = JSON.parse(response.body)
        article_ids = json_response['articles'].map { |a| a['id'] }
        expect(article_ids.count).to eq(created_article_count)
        expect(article_ids).to eq([article_2.id, article_1.id])
      end
    end

    describe 'failure' do
      let!(:article) { create(:article, user: user, category: category) }
      let(:failure_params) do
        {
          category_id: 0
        }
      end

      it 'returns 404 when Category is not found' do
        get :index, params: failure_params, format: :json
        expect(response.status).to eq 404
      end
    end
  end
end
