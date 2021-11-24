require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  describe '#index' do
    describe 'success' do
      let!(:article_1) { create(:article, user: user, category: category, created_at: Date.yesterday) }
      let!(:article_2) { create(:article, user: user, category: category, created_at: Date.today) }
      let(:created_article_count) { 2 }
      let(:params) do
        {}
      end

      it 'returns Articles' do
        get :index, params: params, format: :json

        json_response = JSON.parse(response.body)
        article_ids = json_response['articles'].map { |a| a['id'] }
        expect(article_ids.count).to eq(created_article_count)
        expect(article_ids).to eq([article_2.id, article_1.id])

        expect(response.content_type).to include 'application/json'
      end
    end
  end

  describe '#show' do
    describe 'success' do
      let!(:article) { create(:article, user: user) }
      let(:params) do
        {
          id: article.id
        }
      end

      it 'returns an Article' do
        get :show, params: params, format: :json

        json_response = JSON.parse(response.body)

        expect(json_response['article']['id']).to eq(article.id)
        expect(json_response['article']['title']).to eq(article.title)
        expect(json_response['article']['body']).to eq(article.body)
        expect(json_response['article']['category']).to be_present

        expect(response.content_type).to include 'application/json'
      end
    end

    describe 'failure' do
      let!(:article) { create(:article, user: user) }
      let(:failure_params) do
        {
          id: 0
        }
      end

      it 'returns 404 when Article is not found' do
        get :show, params: failure_params, format: :json
        expect(response.status).to eq 404
      end
    end
  end

  describe '#create' do
    describe 'success' do
      let!(:article) { create(:article, user: user, category: category) }
      let(:params) do
        {
          article: {
            title: article.title,
            category_id: category.id,
            body: article.body
          }
        }
      end

      it 'creates and returns an Article' do
        allow(subject).to receive(:current_user).and_return(user)

        expect {
          post :create, params: params, format: :json
        }.to change(Article, :count).by(1)

        json_response = JSON.parse(response.body)

        expect(json_response['article']['title']).to eq(article.title)
        expect(json_response['article']['body']).to eq(article.body)
        expect(json_response['article']['category']['id']).to eq(category.id)

        expect(response.content_type).to include 'application/json'
      end
    end

    describe 'failure' do
      let(:article) { create(:article, user: user, category: category) }
      let(:params) do
        {
          article: {
            title: article.title,
            category_id: category.id,
            body: article.body
          }
        }
      end

      let(:invalid_params) do
        {
          article: {
            title: "",
            category_id: "",
            body: ""
          }
        }
      end

      it 'returns unauthorized when user is not logged in' do
        post :create, params: params, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns errors if params are invalid' do
        allow(subject).to receive(:current_user).and_return(user)

        post :create, params: invalid_params, format: :json
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe '#update' do
    describe 'success' do
      let(:article_1) { create(:article, user: user, category: category) }
      let(:article_2) { create(:article, user: user, category: category) }
      let(:params) do
        {
          id: article_1.id,
          article: {
            title: article_2.title,
            category_id: category.id,
            body: article_2.body
          }
        }
      end

      it 'updates and returns a new Article params' do
        allow(subject).to receive(:current_user).and_return(user)
        put :update, params: params, format: :json
        json_response = JSON.parse(response.body)

        expect(json_response['article']['title']).to eq(article_2.title)
        expect(json_response['article']['body']).to eq(article_2.body)
        expect(json_response['article']['category']['id']).to eq(category.id)

        expect(response.content_type).to include 'application/json'
      end
    end

    describe 'failure' do
      let(:unauthorized_user) { create(:user) }
      let(:article) { create(:article, user: user, category: category) }
      let(:params) do
        {
          id: article.id,
          article: {
            title: article.title,
            category_id: category.id,
            body: article.body
          }
        }
      end

      let(:not_found_params) do
        {
          id: 0
        }
      end

      let(:invalid_params) do
        {
          id: article.id,
          article: {
            title: "",
            category_id: "",
            body: ""
          }
        }
      end

      it 'returns 404 when no Article is found' do
        allow(subject).to receive(:current_user).and_return(user)

        put :update, params: not_found_params, format: :json
        expect(response.status).to eq 404
      end

      it 'returns unauthorized when user is not logged in' do
        put :update, params: params, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns forbidden when user tries to access Article that he does not own' do
        allow(subject).to receive(:current_user).and_return(unauthorized_user)

        put :update, params: params, format: :json
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns errors if params are invalid' do
        allow(subject).to receive(:current_user).and_return(user)

        put :update, params: invalid_params, format: :json
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe '#delete' do
    describe 'success' do
      let!(:article) { create(:article, user: user, category: category) }

      let(:params) do
        {
          id: article.id
        }
      end

      it 'deletes an Article' do
        allow(subject).to receive(:current_user).and_return(user)

        expect {
          delete :destroy, params: params, format: :json
        }.to change(Article, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    describe 'failure' do
      let(:unauthorized_user) { create(:user) }
      let(:article) { create(:article, user: user, category: category) }

      let(:params) do
        {
          id: article.id
        }
      end

      let(:not_found_params) do
        {
          id: 0
        }
      end

      it 'returns 404 when no Article is found' do
        allow(subject).to receive(:current_user).and_return(user)

        delete :destroy, params: not_found_params, format: :json
        expect(response.status).to eq 404
      end

      it 'returns unauthorized when user is not logged in' do
        delete :destroy, params: params, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns forbidden when user tries to delete Article that he does not own' do
        allow(subject).to receive(:current_user).and_return(unauthorized_user)

        delete :destroy, params: params, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
