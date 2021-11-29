# frozen_string_literal: true

RSpec.shared_examples 'has validation errors' do
  it 'has validation errors' do
    expect(form.save).to be_falsey
    expect(form).not_to be_persisted
    expect(form.errors.to_hash).to eq(expected_error_messages)
  end
end
