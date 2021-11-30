RSpec.describe ArticleUpdateForm do
  subject(:form) { described_class.new(article, attributes) }

  let(:user) { create(:user) }
  let(:category_1) { create(:category) }
  let(:category_2) { create(:category) }
  let!(:article) { create(:article, user: user, category: category_1) }

  let(:new_category_id) { category_2.id }
  let(:new_title) { FFaker::Book.title }
  let(:new_body) { FFaker::Lorem.sentence }

  let(:attributes) do
    {
      category_id: new_category_id,
      title: new_title,
      body: new_body
    }
  end

  describe 'success' do
    describe 'update all article fields' do

      it 'update article with new attributes' do
        expect(form).to be_valid
        form.save

        new_article = form.model

        expect(new_article.category_id).to eq(new_category_id)
        expect(new_article.title).to eq(new_title)
        expect(new_article.body).to eq(new_body)
      end
    end
  end

  describe 'failure' do
    describe 'category_id validations' do
      context 'when category_id is empty' do
        let(:new_category_id) { '' }
        let(:expected_error_messages) { { category_id: ["must be filled"] } }

        include_examples 'has validation errors'
      end
    end

    describe 'title validations' do
      context 'when title is empty' do
        let(:new_title) { '' }
        let(:expected_error_messages) { { title: ["must be filled"] } }

        include_examples 'has validation errors'
      end

      context 'when title is too long' do
        let(:new_title) { FFaker::Lorem.characters(Article::MAX_TITLE_LENGTH + 1) }
        let(:expected_error_messages) { { title: ["size cannot be greater than 100"] } }

        include_examples 'has validation errors'
      end
    end

    describe 'body validations' do
      context 'when body is empty' do
        let(:new_body) { '' }
        let(:expected_error_messages) { { body: ["must be filled"] } }

        include_examples 'has validation errors'
      end

      context 'when body is too long' do
        let(:new_body) { FFaker::Lorem.characters(Article::MAX_BODY_LENGTH + 1) }
        let(:expected_error_messages) { { body: ["size cannot be greater than 50000"] } }

        include_examples 'has validation errors'
      end
    end
  end
end
