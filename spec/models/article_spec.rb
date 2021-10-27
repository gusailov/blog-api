require 'rails_helper'

RSpec.describe Article, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_most(100) }
end
