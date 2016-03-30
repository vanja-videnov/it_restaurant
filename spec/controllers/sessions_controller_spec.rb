require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  subject(:user) { User.new(email: email, password: password, telephone: telephone, name: name, manager: manager)}
  let(:email) { 'vanja@rbt.com' }
  let(:password) { '123456vv' }
  let(:telephone) { '0643335504' }
  let(:name) { 'Vanja' }
  let(:manager) { true}
  it { expect(user).to be_valid }

  include SessionsHelper

  describe 'GET #new' do
    context 'when is not logged in' do
      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
      end

      it 'renders login form' do
        get :new
        expect(response). to render_template :new
      end
    end
    context 'when is logged in waiter' do
      before do
        @waiter = create(:user_waiter)
        log_in(@waiter)
      end
      after do
        log_out
      end
      it 'redirect to tables path' do
        get :new
        expect(response).to redirect_to tables_path
      end
    end

    context 'when is logged in manager' do
      before do
        @manager = create(:user_waiter, manager: true)
        log_in(@manager)
      end
      after do
        log_out
      end
      it 'redirect to manager dashboard' do
        get :new
        expect(response).to redirect_to manager_index_path
      end
    end
  end

  describe 'POST #new' do
    before do
      user.save
      @user_waiter = create(:user_waiter)
    end

    it 'renders login page for wrong login params' do
      post :create, session: {email: "", password: ""}
      #assert_template 'sessions/new'
      expect(response).to render_template :new
      expect(flash[:danger]).to be_present
    end

    it 'renders manager index page for right login params for manager' do
      post :create, session: {email: 'vanja@rbt.com', password: '123456vv'}
      #assert_template 'sessions/new'
      expect(response).to redirect_to(manager_index_path)
    end

    it 'renders profile page for right login params for regular user' do
      post :create, session: {email: "sanja@rbt.com", password: "123456vv"}
      #assert_template 'sessions/new'
      expect(response).to redirect_to(edit_user_path(id: @user_waiter.id))
    end

  end

  describe 'DELETE #destroy' do
    it 'renders home page' do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end

end
