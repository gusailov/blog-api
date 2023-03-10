RSpec.describe Comment, type: :model do
  describe 'Constants' do
    it { expect(described_class::MAX_BODY_LENGTH).to eq(1000) }
  end

  describe 'Fields' do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
    it { is_expected.to have_db_column(:article_id).of_type(:integer) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }

    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:article_id) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:article) }
  end
end
