RSpec.describe ArticleFilter do
  let(:user) { create(:user) }

  subject { ArticleFilter.new(Article.all) }

  describe 'no params' do
    let(:article) { create_list(:article, user: user) }

    let(:params) do
      {}
    end
    let(:filtered_articles) { subject.call(params) }

    it 'returns all Articles if params empty' do
      expect(filtered_articles).to eq(Article.all)
    end
  end

  describe 'search by title' do
    context 'full title' do
      let(:article_1) { create(:article, user: user) }
      let(:article_2) { create(:article, user: user) }
      let(:filtered_article_count) { 1 }

      let(:params) do
        {
          search: article_1.title
        }
      end
      
      let(:filtered_articles) { subject.call(params) }

      it 'returns 1 Article if full title in search' do
        expect(filtered_articles.count).to eq(filtered_article_count)
        expect(filtered_articles).to include(article_1)
        expect(filtered_articles).to_not include(article_2)
      end
    end

    context 'part of title' do
      let(:created_article_count) { 2 }
      let!(:article_1) { create(:article, user: user, title: 'FDSA') }
      let!(:article_2) { create(:article, user: user, title: 'ASDF') }

      let(:params) do
        {
          search: "A"
        }
      end

      let(:filtered_articles) { subject.call(params) }
      let(:expected_articles_found) { [article_1, article_2] }

      it 'returns Articles with the necessary letter in the title' do
        expect(filtered_articles.count).to eq(created_article_count)
        expect(filtered_articles).to eq(expected_articles_found)
      end
    end
  end

  describe 'search by date' do
    let!(:article_1) { create(:article, user: user, created_at: Date.yesterday) }
    let!(:article_2) { create(:article, user: user, created_at: Date.today) }
    let(:filtered_article_count) { 1 }

    let(:params) do
      {
        date: Date.today.iso8601
      }
    end

    let(:filtered_articles) { subject.call(params) }

    it 'returns articles of the search date' do
      expect(filtered_articles.count).to eq(filtered_article_count)
      expect(filtered_articles).to include(article_2)
      expect(filtered_articles).to_not include(article_1)
    end
  end
end
