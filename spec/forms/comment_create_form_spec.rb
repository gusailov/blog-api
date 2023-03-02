RSpec.describe CommentCreateForm do
  subject(:form) { described_class.new(attributes) }

  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }
  let(:user_id) { user.id }
  let(:article_id) { article.id }
  let(:body) { FFaker::Lorem.sentence }

  let(:attributes) do
    {
      user_id: user_id,
      article_id: article_id,
      body: body
    }
  end

  describe 'success' do
    it 'create new Comment in database' do
      expect(form).to be_valid
      expect { form.save }.to change(Comment, :count).by(1)

      article = form.model

      expect(article.user_id).to eq(user_id)
      expect(article.article_id).to eq(article_id)
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

    describe 'article_id validations' do
      context 'when article_id is empty' do
        let(:article_id) { nil }
        let(:expected_error_messages) { { article_id: ["must be filled"] } }

        include_examples 'has validation errors'
      end
    end

    describe 'body validations' do
      context 'when body is empty' do
        let(:body) { nil }
        let(:expected_error_messages) { { body: ["must be filled"] } }

        include_examples 'has validation errors'
      end

      context 'when title is too long' do
        let(:body) { FFaker::Lorem.characters(Comment::MAX_BODY_LENGTH + 1) }
        let(:expected_error_messages) { { body: ["size cannot be greater than 1000"] } }

        include_examples 'has validation errors'
      end
    end
  end
end
