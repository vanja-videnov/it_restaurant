require 'rails_helper'

RSpec.describe Manager::UsersController, type: :controller do
  include SessionsHelper
  subject(:user) { User.new(email: email, password: password, telephone: telephone, name: name, manager: manager)}
  let(:email) { 'vanja@rbt.com' }
  let(:password) { '123456vv' }
  let(:telephone) { '0643335504' }
  let(:name) { 'Vanja' }
  let(:manager) { true}
  it { expect(user).to be_valid }

  before do
    user.save
    log_in(user)
    @user_waiter = create(:user_waiter)
    @users = [user, @user_waiter]
  end
  after do
    log_out
  end

  describe 'GET #new' do
    it 'renders the new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before do
      @count = User.count
      @count+=1
    end

    context 'when params are valid' do
      it 'creates new instance of user' do
        post :create, user: attributes_for(:user_waiter, email: 'sanja2@rbt.com')
        expect(User.count).to eq(@count)
      end

      it 'show root path' do
        post :create,  user: attributes_for(:user_waiter, email: 'sanja2@rbt.com')
        expect(response).to redirect_to manager_index_path
      end
    end

    context 'when params are not valid' do
      it 'dont create new instance of user' do
        post :create, user: attributes_for(:user_waiter, email: 'srbt.com')
        expect(User.count).not_to eq(@count)
      end

      it 'renders form again' do
        post :create,  user: attributes_for(:user_waiter, email: 's2rbt.com')
        expect(response).to render_template :new
      end
    end

  end


  describe 'DELETE #destroy' do
    context 'when is admin' do
      it 'delete selected user' do
        delete :destroy, id: @user_waiter
        expect(User.exists?(@user_waiter.id)).to be_falsey
      end

      it 'expect to render index page' do
        delete :destroy, id: @user_waiter
        expect(response). to redirect_to(users_path)
      end
    end
    context 'when is not admin' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(user)
      end
      it 'dont delete selected user' do
        delete :destroy, id: user
        expect(User.exists?(user.id)).not_to be_falsey
      end

    end

  end

end
