require 'rails_helper'

RSpec.describe Item, type: :model do
  subject(:item) { Item.new(name: name, description: description, price: price)}
  let(:name) { 'Palma' }
  let(:description) { 'Penne with garlic, ginger and orange sauce' }
  let(:price) { 324 }
  it { expect(item).to be_valid }

  describe '#name' do
    context 'when is ok' do
      let(:name) { 'Palma2' }
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

  describe '#description' do
    context 'when is ok' do
      let(:description) { 'this is desc for item' }
      it { expect(subject).to be_valid }
    end

    context 'when is not present' do
      let(:description) { '' }
      it { expect(subject).to be_invalid }
    end

    context 'when is nil' do
      let(:description) { nil }
      it { expect(subject).to be_invalid }
    end
  end

  describe '#price' do
    context 'when is ok' do
      let(:price) { 555 }
      it { expect(subject).to be_valid }
    end

    context 'when is not present' do
      let(:price) {  }
      it { expect(subject).to be_invalid }
    end

    context 'when is nil' do
      let(:price) { nil }
      it { expect(subject).to be_invalid }
    end

    context 'when is not integer' do
      let(:price) { 'sahsaii' }
      it { expect(subject).to be_invalid }
    end

    context 'when is not round number' do
      let(:price) { 32.3 }
      it { expect(subject).to be_invalid }
    end

  end

end
