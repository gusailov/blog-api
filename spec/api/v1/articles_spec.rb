require 'rails_helper'

describe 'Articles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  describe 'GET api/v1/articles' do
    let(:api_path) { '/api/v1/articles' }
    let!(:articles) { create_list(:article, 2, user: user, category: category) }
    let(:article) { articles.first }
    let(:article_response) { json['articles'].last }

    before { get api_path, headers: headers }

    it_behaves_like 'status 200'

    it 'returns list of articles' do
      expect(json['articles'].size).to eq 2
    end

    it 'returns all public fields' do
      %w[id title created_at].each do |attr|
        expect(article_response[attr]).to eq article.send(attr).as_json
      end
    end

    it 'contains short body' do
      expect(article_response['body_cut']).to eq article.body.truncate(500)
    end

    it 'contains category object' do
      expect(article_response['category']['id']).to eq article.category.id
    end
  end

  describe 'GET api/v1/articles/:id' do
    let!(:article) { create(:article, user: user, category: category) }
    let(:api_path) { "/api/v1/articles/#{article.id}" }
    let(:article_response) { json['article'] }
    let!(:comments) { create_list(:comment, 2, user: user, article: article) }

    before { get api_path, headers: headers }

    it_behaves_like 'status 200'

    it 'returns all public fields' do
      %w[id title body created_at].each do |attr|
        expect(article_response[attr]).to eq article.send(attr).as_json
      end
    end

    it 'contains article comments' do
      expect(article_response['comments'].size).to eq 2
    end

    it 'contains category object' do
      expect(article_response['category']['id']).to eq article.category.id
    end
  end

  describe "POST api/v1/articles" do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { '/api/v1/articles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      before {
        sign_up(user)
      }
      let(:auth_tokens) { auth_tokens_for_user(user) }
      let (:params) { { article: attributes_for(:article).merge(category_id: category.id) } }

      before {
        post api_path, params: params,
             headers: headers.merge(auth_tokens)
      }

      it_behaves_like 'status 200'

      it 'create article' do
        expect {
          post api_path, params: params,
               headers: headers.merge(auth_tokens)
        }.to change(Article, :count).by(1)
      end
    end
  end

  describe 'DELETE /api/v1/articles/:id' do
    let!(:article) { create(:article, user: user, category: category) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { "/api/v1/articles/#{article.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      before {
        sign_up(user)
      }
      let (:auth_tokens) { auth_tokens_for_user(user) }

      it 'returns 200 status' do
        delete api_path, headers: headers.merge(auth_tokens)
        expect(response).to be_successful
      end

      it 'delete article' do
        expect {
          delete api_path, headers: headers.merge(auth_tokens)
        }.to change(Article, :count).by(-1)
      end
    end

    context 'not authorized' do
      let (:not_author) { create(:user) }
      before {
        sign_up(not_author)
      }
      let (:auth_tokens) { auth_tokens_for_user(not_author) }

      it 'returns 403 status' do
        delete api_path, headers: headers.merge(auth_tokens)
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'GET /api/v1/categories/:category_id/articles' do
    let(:api_path) { "/api/v1/categories/#{category.id}/articles" }
    let!(:articles) { create_list(:article, 3, user: user, category: category) }
    before { get api_path, headers: headers }

    it_behaves_like 'status 200'

    it 'returns list of articles of category' do
      expect(json['articles'].size).to eq 3
    end

    it 'returns specific category' do
      expect(json['articles'].first['category']['id']).to eq category.id
    end
  end

  describe 'GET /api/v1/users/:user_id/articles' do
    let(:api_path) { "/api/v1/users/#{user.id}/articles" }
    let!(:articles) { create_list(:article, 3, user: user, category: category) }
    before { get api_path, headers: headers }

    it_behaves_like 'status 200'

    it 'returns list of articles of user' do
      expect(json['articles'].size).to eq 3
    end
  end
end