require 'rails_helper'

RSpec.describe Subcategory, type: :model do
  subject(:subcategory) { Subcategory.new(name: name)}
  let(:name) { 'alcoholic' }
  it { expect(subcategory).to be_valid }

  describe '#name' do
    context 'when is ok' do
      let(:name) { 'water' }
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
