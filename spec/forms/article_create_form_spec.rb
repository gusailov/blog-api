RSpec.describe ArticleCreateForm do
  subject(:form) { described_class.new(attributes) }

  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:user_id) { user.id }
  let(:category_id) { category.id }
  let(:title) { FFaker::Book.title }
  let(:body) { FFaker::Lorem.characters }

  let(:attributes) do
    {
      user_id: user_id,
      category_id: category_id,
      title: title,
      body: body
    }
  end

  describe 'success' do
    it 'create new Article in database' do
      expect(form).to be_valid
      expect { form.save }.to change(Article, :count).by(1)

      article = form.model

      expect(article.user_id).to eq(user_id)
      expect(article.category_id).to eq(category_id)
      expect(article.title).to eq(title)
      expect(article.body).to eq(body)
    end
  end

  describe 'failure' do
    describe 'user_id validations' do
      context 'when user_id is empty' do
        let(:user_id) { nil }
        let(:expected_error_messages) { { user_id: ["must be filled"] } }

        include_examples 'has validation errors'
      end
    end

    describe 'category_id validations' do
      context 'when category_id is empty' do
        let(:category_id) { nil }
        let(:expected_error_messages) { { category_id: ["must be filled"] } }

        include_examples 'has validation errors'
      end
    end

    describe 'title validations' do
      context 'when title is empty' do
        let(:title) { nil }
        let(:expected_error_messages) { { title: ["must be filled"] } }

        include_examples 'has validation errors'
      end

      context 'when title is too long' do
        let(:title) { FFaker::Lorem.characters(Article::MAX_TITLE_LENGTH + 1) }
        let(:expected_error_messages) { { title: ["size cannot be greater than 100"] } }

        include_examples 'has validation errors'
      end
    end

    describe 'body validations' do
      context 'when body is empty' do
        let(:body) { nil }
        let(:expected_error_messages) { { body: ["must be filled"] } }

        include_examples 'has validation errors'
      end

      context 'when body is too long' do
        let(:body) { FFaker::Lorem.characters(Article::MAX_BODY_LENGTH + 1) }
        let(:expected_error_messages) { { body: ["size cannot be greater than 50000"] } }

        include_examples 'has validation errors'
      end
    end
  end
end
