require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { Category.new(name: name)}
  let(:name) { 'drink' }
  it { expect(category).to be_valid }

  describe '#name' do
    context 'when is ok' do
      let(:name) { 'to go' }
      it { expect(subject).to be_valid }
    end

    context 'when is not present' do
      let(:name) { '' }
      it { expect(subject).to be_invalid }
    end

    context 'when is nil' do
      let(:name) { nil }
      it { expect(subject).to be_invalid }
    end
  end
end
