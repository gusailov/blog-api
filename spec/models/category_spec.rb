require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'Fields' do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }

    it { is_expected.to have_db_index(:name).unique(true) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:articles).dependent(:destroy) }
  end

  describe 'Validations' do
    subject { Category.new(name: "something") }
    
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
