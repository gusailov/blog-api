RSpec.describe Article, type: :model do
  describe 'Constants' do
    it { expect(described_class::MAX_TITLE_LENGTH).to eq(100) }
    it { expect(described_class::MAX_BODY_LENGTH).to eq(50000) }
  end

  describe 'Fields' do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:title).of_type(:string).with_options(limit: 100) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:category_id).of_type(:integer) }

    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:category_id) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end
end
