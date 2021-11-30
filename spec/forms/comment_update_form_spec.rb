RSpec.describe CommentUpdateForm do
  subject(:form) { described_class.new(comment, attributes) }

  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }
  let!(:comment) { create(:comment, article: article, user: user) }

  let(:new_body) { FFaker::Lorem.characters }

  let(:attributes) do
    {
      body: new_body
    }
  end

  describe 'success' do
    describe 'update all comment fields' do
      it 'update comment with new attributes' do
        expect(form).to be_valid
        form.save

        new_comment = form.model

        expect(new_comment.body).to eq(new_body)
      end
    end
  end

  describe 'failure' do
    describe 'body validations' do
      context 'when body is empty' do
        let(:new_body) { '' }
        let(:expected_error_messages) { { body: ["can't be blank"] } }

        include_examples 'has validation errors'
      end

      context 'when body is too long' do
        let(:new_body) { FFaker::Lorem.characters(Comment::MAX_BODY_LENGTH + 1) }
        let(:expected_error_messages) { { body: ["is too long (maximum is 1000 characters)"] } }

        include_examples 'has validation errors'
      end
    end
  end
end
