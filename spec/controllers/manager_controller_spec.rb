require 'rails_helper'

RSpec.describe ManagerController, type: :controller do
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
  end
  after do
    log_out
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'renders manager index page' do
      get :index
      expect(response). to render_template :index
    end
  end

  describe '#require_manager' do

    context 'when is not manager but logged in' do
      before do
        log_out
        @user_waiter = create(:user_waiter)
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(user)
      end
      it 'renders root page' do
        get :require_manager
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(user)
      end
      it 'renders root page' do
        get :require_manager
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
