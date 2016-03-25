require 'rails_helper'

RSpec.describe Menu, type: :model do
  subject(:menu) { Menu.new(date: date)}
  let(:date) { '2014-12-12' }
  it { expect(menu).to be_valid }
  describe '#date' do
    context 'when is not valid format' do
      let(:date) { '2014-32-12' }

      it { expect(subject).to be_invalid }
    end
  end
end
