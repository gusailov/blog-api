RSpec.describe ArticleSerializer do
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }

  let(:serialized_article) { ArticleSerializer.new(article).to_h }

  it 'returns Article created_at field in iso8601 format' do
    expect(serialized_article[:created_at]).to eq(article.created_at.iso8601)
  end
end
