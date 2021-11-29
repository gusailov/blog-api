RSpec.describe CategoriesUpdateForm do
  subject(:form) { described_class.new(category, attributes) }

  let!(:category) { create(:category) }
  let(:new_name) { FFaker::Book.title }

  let(:attributes) do
    {
      name: new_name
    }
  end

  describe 'success' do
    describe 'update all category fields' do
      it 'update category with new attributes' do
        expect(form).to be_valid
        form.save

        new_category = form.model

        expect(new_category.name).to eq(new_name)
      end
    end
  end

  describe 'failure' do
    describe 'name validations' do
      context 'when name is empty' do
        let(:new_name) { '' }
        let(:expected_error_messages) { { name: ["can't be blank"] } }

        include_examples 'has validation errors'
      end

      context 'when category name already exists' do
        let(:new_name) { category.name }
        let(:expected_error_messages) { { name: ["has already been taken"] } }

        include_examples 'has validation errors'
      end
    end
  end
end
