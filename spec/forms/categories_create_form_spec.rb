RSpec.describe CategoriesCreateForm do
  subject(:form) { described_class.new(attributes) }

  let(:name) { FFaker::Book.title }

  let(:attributes) do
    {
      name: name
    }
  end

  describe 'success' do
    it 'create new Category in database' do
      expect(form).to be_valid
      expect { form.save }.to change(Category, :count).by(1)

      category = form.model

      expect(category.name).to eq(name)
    end
  end

  describe 'failure' do
    describe 'title validations' do
      context 'when title is empty' do
        let(:name) { nil }
        let(:expected_error_messages) { { name: ["must be filled"] } }

        include_examples 'has validation errors'
      end

      context 'when category name already exists' do
        let(:category) { create(:category) }
        let(:name) { category.name }
        let(:expected_error_messages) { { name: ["has already been taken"] } }

        include_examples 'has validation errors'
      end
    end
  end
end
