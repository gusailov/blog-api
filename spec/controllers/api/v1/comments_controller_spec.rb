RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }

  describe '#index' do
    describe 'success' do
      let!(:comment_1) { create(:comment, article: article, user: user) }
      let!(:comment_2) { create(:comment, article: article, user: user) }
      let(:created_comment_count) { 2 }
      let(:params) do
        {
          article_id: article.id
        }
      end

      it 'returns Comments' do
        get :index, params: params, format: :json

        json_response = JSON.parse(response.body)
        comment_ids = json_response['comments'].map { |c| c['id'] }
        expect(comment_ids.count).to eq(created_comment_count)
        expect(comment_ids).to eq([comment_2.id, comment_1.id])

        expect(response.content_type).to include 'application/json'
      end
    end
  end

  describe '#create' do
    describe 'success' do
      let!(:comment) { create(:comment, article: article, user: user) }
      let(:params) do
        {
          article_id: article.id,
          body: comment.body
        }
      end

      it 'creates and returns an Comment' do
        allow(subject).to receive(:current_user).and_return(user)

        expect {
          post :create, params: params, format: :json
        }.to change(Comment, :count).by(1)

        json_response = JSON.parse(response.body)

        expect(json_response['comment']['body']).to eq(comment.body)
        expect(json_response['comment']['article_id']).to eq(article.id)

        expect(response.content_type).to include 'application/json'
      end
    end

    describe 'failure' do
      let!(:comment) { create(:comment, article: article, user: user) }
      let(:params) do
        {
          article_id: article.id,
          body: comment.body
        }
      end

      let(:invalid_params) do
        {
          article_id: article.id,
          body: ""
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
      let!(:comment) { create(:comment, article: article, user: user) }
      let(:new_comment_name) { "New Name" }
      let(:params) do
        {
          article_id: article.id,
          id: comment.id,
          body: new_comment_name
        }
      end
      it 'updates and returns a new Comment params' do
        allow(subject).to receive(:current_user).and_return(user)
        put :update, params: params, format: :json
        json_response = JSON.parse(response.body)

        expect(json_response['comment']['body']).to eq(new_comment_name)

        expect(response.content_type).to include 'application/json'
      end
    end

    describe 'failure' do
      let(:unauthorized_user) { create(:user) }
      let!(:comment) { create(:comment, article: article, user: user) }
      let(:new_comment_name) { "New Name" }
      let(:params) do
        {
          article_id: article.id,
          id: comment.id,
          body: new_comment_name
        }
      end

      let(:not_found_params) do
        {
          article_id: article.id,
          id: 0
        }
      end

      let(:invalid_params) do
        {
          article_id: article.id,
          id: comment.id,
          body: ""
        }
      end

      it 'returns 404 when no Comment is found' do
        allow(subject).to receive(:current_user).and_return(user)

        put :update, params: not_found_params, format: :json
        expect(response.status).to eq 404
      end

      it 'returns unauthorized when user is not logged in' do
        put :update, params: params, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns forbidden when user tries to access Comment that he does not own' do
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
      let!(:comment) { create(:comment, article: article, user: user) }
      let(:params) do
        {
          article_id: article.id,
          id: comment.id
        }
      end

      it 'deletes a Comment' do
        allow(subject).to receive(:current_user).and_return(user)

        expect {
          delete :destroy, params: params, format: :json
        }.to change(Comment, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    describe 'failure' do
      let(:unauthorized_user) { create(:user) }
      let!(:comment) { create(:comment, article: article, user: user) }
      let(:params) do
        {
          article_id: article.id,
          id: comment.id
        }
      end

      let(:not_found_params) do
        {
          article_id: article.id,
          id: 0
        }
      end

      it 'returns 404 when no Comment is found' do
        allow(subject).to receive(:current_user).and_return(user)

        delete :destroy, params: not_found_params, format: :json
        expect(response.status).to eq 404
      end

      it 'returns unauthorized when user is not logged in' do
        delete :destroy, params: params, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns forbidden when user tries to delete Comment that he does not own' do
        allow(subject).to receive(:current_user).and_return(unauthorized_user)

        delete :destroy, params: params, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
