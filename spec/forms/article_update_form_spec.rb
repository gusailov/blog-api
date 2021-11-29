RSpec.describe ArticleUpdateForm do
  subject(:form) { described_class.new(article, attributes) }

  let(:user) { create(:user) }
  let(:category_1) { create(:category) }
  let(:category_2) { create(:category) }
  let!(:article) { create(:article, user: user, category: category_1) }

  let(:new_category_id) { category_2.id }
  let(:new_title) { FFaker::Book.title }
  let(:new_body) { FFaker::Lorem.sentences.join(' ') }

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
        let(:expected_error_messages) { { category_id: ["can't be blank"] } }

        include_examples 'has validation errors'
      end
    end

    describe 'title validations' do
      context 'when title is empty' do
        let(:new_title) { '' }
        let(:expected_error_messages) { { title: ["can't be blank"] } }

        include_examples 'has validation errors'
      end

      context 'when title is too long' do
        let(:new_title) { SecureRandom.alphanumeric(200) }
        let(:expected_error_messages) { { title: ["is too long (maximum is 100 characters)"] } }

        include_examples 'has validation errors'
      end
    end

    describe 'body validations' do
      context 'when body is empty' do
        let(:new_body) { '' }
        let(:expected_error_messages) { { body: ["can't be blank"] } }

        include_examples 'has validation errors'
      end

      context 'when body is too long' do
        let(:new_body) { SecureRandom.alphanumeric(60000) }
        let(:expected_error_messages) { { body: ["is too long (maximum is 50000 characters)"] } }

        include_examples 'has validation errors'
      end
    end
  end
end
