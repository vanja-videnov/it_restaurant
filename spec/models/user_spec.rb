require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.new(email: email, password: password, telephone: telephone, name: name, manager: manager)}
  let(:email) { 'vanja@rbt.com' }
  let(:password) { '123456vv' }
  let(:telephone) { '0643335504' }
  let(:name) { 'Vanja' }
  let(:manager) { true}
  it { expect(user).to be_valid }

  shared_examples_for 'an invalid user' do
    before do

      subject.validate  #for creating errors
    end
    it { expect(subject).to be_invalid }
    it 'should show errors' do
      expect(subject.errors).to be_present
    end
  end
  shared_examples_for 'a valid user' do
    it { should be_valid }
  end

  describe '#email' do

    context 'when too long' do
      let(:email) { 'reallyreallyreallyreallyreallyreallyreallyreallylongemailthatiscrazyemailbutisisjustfortest@rbt.com' }

      it_behaves_like 'an invalid user'
    end

    context 'when too short' do
      let(:email) {  's@s.s' }

      it_behaves_like 'an invalid user'
    end

    context 'when is not present' do
      let(:email) { '' }

      it_behaves_like 'an invalid user'
    end

    context 'when is not ok format' do
      let(:email) { 'vanjaaaaa' }

      it_behaves_like 'an invalid user'
    end

    context 'when is not unique' do

      before do
        create(:user_waiter)
      end
      let(:email) { 'sanja@rbt.com' }

      it_behaves_like 'an invalid user'
    end
  end

  describe '#password' do

    context 'when too short' do
      let(:password) { 'bla' }

      it_behaves_like 'an invalid user'
    end

    context 'when is not present' do
      let(:password) { '' }

      it_behaves_like 'an invalid user'
    end
  end

  describe '#telephone' do

    context 'when is invalid format' do
      let(:telephone) { '44bhbhhb' }

      it_behaves_like 'an invalid user'
    end

    context 'when is nil' do
      let(:telephone) {nil}

      it_behaves_like 'a valid user'
    end

    context 'when is empty string' do
      let(:telephone) {''}

      it_behaves_like 'a valid user'
    end
  end

  describe '#name' do

    context 'when is nil' do
      let(:name) { nil }

      it_behaves_like 'a valid user'
    end

    context 'when is empty string' do
      let(:name) { '' }

      it_behaves_like 'a valid user'
    end
  end

  describe '#manager' do

    context 'when is boolean value' do
      let(:manager) { true }

      it_behaves_like 'a valid user'
    end

    context 'when is 1 or 0 value' do
      let(:manager) { 1 }

      it_behaves_like 'a valid user'
    end

    context 'when is empty' do
      let(:manager) { '' }

      it_behaves_like 'an invalid user'
    end

    context 'when is nil' do
      let(:manager) { nil }

      it_behaves_like 'an invalid user'
    end

    context 'when is not boolean value' do
      let(:manager) { 'bdskjbdjksbds' }

      it_behaves_like 'a valid user'
    end
  end

  describe '#authenticate' do
    before do
      @user  = FactoryGirl.create(:user_waiter)
    end
    context 'when correct password' do
      it 'returns true' do
        expect(BCrypt::Engine.hash_secret('123456vv', @user.salt)).to eq(@user.password)
        expect(@user.authenticate('123456vv')).to eq(true)
      end
    end
    context 'when not correct password' do
      it 'returns false' do
        expect(@user.authenticate('blaaaa')).to eq(false)
      end
    end
  end


end
