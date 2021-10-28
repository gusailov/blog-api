require 'rails_helper'

describe 'Comments API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:article) { create(:article, user: user, category: category) }

  describe 'GET api/v1/articles/:article_id/comments' do
    let(:api_path) { "/api/v1/articles/#{article.id}/comments" }
    let!(:comments) { create_list(:comment, 3, user: user, article: article) }
    let(:comment) { comments.first }
    let(:comment_response) { json['comments'].first }

    before { get api_path, headers: headers }

    it_behaves_like 'status 200'

    it 'returns list of comments' do
      expect(json['comments'].size).to eq 3
    end

    it ' returns all public fields ' do
      %w[id body user_id created_at].each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end

  end

  describe "POST api/v1/articles/:article_id/comments" do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { "/api/v1/articles/#{article.id}/comments" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      before {
        sign_up(user)
      }
      let(:auth_tokens) { auth_tokens_for_user(user) }
      let (:params) { { comment: attributes_for(:comment) } }

      before {
        post api_path, params: params,
             headers: headers.merge(auth_tokens)
      }

      it_behaves_like 'status 200'

      it 'create comment' do
        expect {
          post api_path, params: params,
               headers: headers.merge(auth_tokens)
        }.to change(Comment, :count).by(1)
      end
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    let!(:comment) { create(:comment, user: user, article: article) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { "/api/v1/comments/#{comment.id}" }

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

      it 'delete comment' do
        expect {
          delete api_path, headers: headers.merge(auth_tokens)
        }.to change(Comment, :count).by(-1)
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
end