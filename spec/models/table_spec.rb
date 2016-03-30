require 'rails_helper'

RSpec.describe Table, type: :model do
  subject(:table) { Table.new(number: number)}
  let(:number) { 3 }
  it { expect(table).to be_valid }

  describe '#number' do
    context 'when is present' do
      let(:number) { 4 }
      it { expect(subject).to be_valid }
    end

    context 'when is not present' do
      let(:number) {  }
      it { expect(subject).to be_invalid }
    end

    context 'when is nil' do
      let(:number) { nil }
      it { expect(subject).to be_invalid }
    end
  end
end
