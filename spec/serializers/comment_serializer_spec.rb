RSpec.describe CommentSerializer do
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }
  let(:comment) { create(:comment, user: user, article: article) }

  let(:serialized_comment) { CommentSerializer.new(comment).to_h }

  it 'returns Comment created_at field in iso8601 format' do
    expect(serialized_comment[:created_at]).to eq(comment.created_at.iso8601)
  end
end
