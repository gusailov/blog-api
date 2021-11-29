RSpec.describe Api::V1::CategoriesController, type: :controller do
  describe '#index' do
    describe 'success' do
      let(:created_category_count) { 2 }
      let!(:categories) { create_list(:category, created_category_count) }

      let(:params) do
        {}
      end

      it 'returns Categories' do
        get :index, params: params, format: :json

        json_response = JSON.parse(response.body)
        category_ids = json_response['categories'].map { |c| c['id'] }

        expect(category_ids.count).to eq(created_category_count)
        expect(response.content_type).to include 'application/json'
      end
    end
  end

  describe '#show' do
    describe 'success' do
      let(:category) { create(:category) }
      let(:params) do
        {
          id: category.id
        }
      end

      it 'returns a Category' do
        get :show, params: params, format: :json

        json_response = JSON.parse(response.body)

        expect(json_response['category']['id']).to eq(category.id)
        expect(json_response['category']['name']).to eq(category.name)

        expect(response.content_type).to include 'application/json'
      end
    end

    describe 'failure' do
      let!(:category) { create(:category) }
      let(:failure_params) do
        {
          id: 0
        }
      end

      it 'returns 404 when Category is not found' do
        get :show, params: failure_params, format: :json
        expect(response.status).to eq 404
      end
    end
  end

  describe '#create' do
    let(:admin_user) { create(:user, :admin) }
    describe 'success' do
      let(:category_name) { FFaker::Book.title }
      let(:params) do
        {
          name: category_name
        }
      end

      it 'creates and returns a Category' do
        allow(subject).to receive(:current_user).and_return(admin_user)

        expect {
          post :create, params: params, format: :json
        }.to change(Category, :count).by(1)

        json_response = JSON.parse(response.body)

        expect(json_response['category']['name']).to eq(category_name)
        expect(response.content_type).to include 'application/json'
      end
    end

    describe 'failure' do
      let(:not_admin_user) { create(:user) }
      let(:category) { create(:category) }
      let(:category_name) { FFaker::Book.title }
      let(:params) do
        {
          name: category_name
        }
      end

      let(:invalid_params) do
        {
          name: ""
        }
      end

      let(:duplicate_params) do
        {
          name: category.name
        }
      end

      it 'returns unauthorized when user is not logged in' do
        post :create, params: params, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns forbidden when user is not an admin' do
        allow(subject).to receive(:current_user).and_return(not_admin_user)

        post :create, params: invalid_params, format: :json
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns errors if params are invalid' do
        allow(subject).to receive(:current_user).and_return(admin_user)

        post :create, params: invalid_params, format: :json
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end

      it 'returns errors if params are with not unique name' do
        allow(subject).to receive(:current_user).and_return(admin_user)

        post :create, params: duplicate_params, format: :json
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe '#update' do
    let(:admin_user) { create(:user, :admin) }
    describe 'success' do
      let(:category) { create(:category) }
      let(:new_category_name) { FFaker::Book.title }
      let(:params) do
        {
          id: category.id,
          name: new_category_name
        }
      end

      it 'updates and returns a new Category params' do
        allow(subject).to receive(:current_user).and_return(admin_user)
        put :update, params: params, format: :json
        json_response = JSON.parse(response.body)

        expect(json_response['category']['name']).to eq(new_category_name)

        expect(response.content_type).to include 'application/json'
      end
    end

    describe 'failure' do
      let(:not_admin_user) { create(:user) }
      let(:category) { create(:category) }
      let(:new_category_name) { "New Name" }
      let(:params) do
        {
          id: category.id,
          name: new_category_name
        }
      end

      let(:not_found_params) do
        {
          id: 0
        }
      end

      let(:invalid_params) do
        {
          id: category.id,
          name: ""
        }
      end

      it 'returns 404 when no Category is found' do
        allow(subject).to receive(:current_user).and_return(admin_user)

        put :update, params: not_found_params, format: :json
        expect(response.status).to eq 404
      end

      it 'returns unauthorized when user is not logged in' do
        put :update, params: params, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns forbidden when user is not an admin' do
        allow(subject).to receive(:current_user).and_return(not_admin_user)

        put :update, params: params, format: :json
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns errors if params are invalid' do
        allow(subject).to receive(:current_user).and_return(admin_user)

        put :update, params: invalid_params, format: :json
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe '#delete' do
    let(:admin_user) { create(:user, :admin) }
    describe 'success' do
      let!(:category) { create(:category) }

      let(:params) do
        {
          id: category.id
        }
      end

      it 'deletes an Category' do
        allow(subject).to receive(:current_user).and_return(admin_user)

        expect {
          delete :destroy, params: params, format: :json
        }.to change(Category, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    describe 'failure' do
      let(:not_admin_user) { create(:user) }
      let(:category) { create(:category) }

      let(:params) do
        {
          id: category.id
        }
      end

      let(:not_found_params) do
        {
          id: 0
        }
      end

      it 'returns 404 when no Category is found' do
        allow(subject).to receive(:current_user).and_return(admin_user)

        delete :destroy, params: not_found_params, format: :json
        expect(response.status).to eq 404
      end

      it 'returns unauthorized when user is not logged in' do
        delete :destroy, params: params, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns forbidden when user is not an admin' do
        allow(subject).to receive(:current_user).and_return(not_admin_user)

        delete :destroy, params: params, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
