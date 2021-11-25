RSpec.describe ArticlesSerializer do
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user, body: SecureRandom.alphanumeric(600)) }

  let(:serialized_article) { ArticlesSerializer.new(article).to_h }
  let(:expected_truncated_body) { "#{article.body[0..496]}..." }

  it 'returns truncated Article body' do
    expect(serialized_article[:body_cut]).to eq(expected_truncated_body)
  end

  it 'returns Article created_at field in iso8601 format' do
    expect(serialized_article[:created_at]).to eq(article.created_at.iso8601)
  end
end
