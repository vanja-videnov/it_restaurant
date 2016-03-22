require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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

  describe 'GET #index' do

    context 'when is manager' do
      it 'renders the index view' do
        get :index
        expect(response).to render_template :index
      end

      it 'shows all users' do
        get :index
        expect(assigns(:users)).to eq(@users)
      end
    end

    context 'when is not manager' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(user)
      end
      it 'renders the index view' do
        get :index
        expect(response).to render_template :index
      end

      it 'shows all users' do
        get :index
        expect(assigns(:users)).to eq(@users)
      end
    end
  end

  describe 'GET #show' do

    context 'when is manager' do
      it 'renders the show view' do
        get :show, id: @user_waiter
        expect(response).to render_template :show
      end

      it 'shows specific user' do
        get :show, id: @user_waiter
        expect(assigns(:user)).to eq(@user_waiter)
      end
    end

    context 'when is not manager' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(user)
      end
      it 'renders the show view' do
        get :show, id: @user_waiter
        expect(response).to render_template :show
      end

      it 'shows specific user' do
        get :show, id: @user_waiter
        expect(assigns(:user)).to eq(@user_waiter)
      end
    end
  end

  describe 'GET #edit' do
    context 'when is not current user' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(user)
      end
      it 'dont render the edit view' do
        get :edit, id: user.id
        expect(response).not_to render_template :edit
      end

      it 'dont show specific user' do
        get :edit, id: user.id
        expect(assigns(:user)).not_to eq(user)
      end
    end

    context 'when is current user' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(user)
      end
      it 'renders the edit view' do
        get :edit, id: @user_waiter
        expect(response).to render_template :edit
      end

      it 'shows specific user' do
        get :edit, id: @user_waiter
        expect(assigns(:user)).to eq(@user_waiter)
      end
    end

    context 'when is manager user and edit himself' do
      it 'renders the edit view' do
        get :edit, id: user
        expect(response).to render_template :edit
      end

      it 'shows specific user' do
        get :edit, id: user
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'when is manager user and edit other user' do
      it 'renders the edit view' do
        get :edit, id: @user_waiter
        expect(response).to render_template :edit
      end

      it 'shows specific user' do
        get :edit, id: @user_waiter
        expect(assigns(:user)).to eq(@user_waiter)
      end
    end
  end

  describe 'PATCH #update' do

    context 'when is current user' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(user)
      end
      context 'when params are not valid' do
        it 'dont update specific user' do
          patch :update, id: @user_waiter.id, user: attributes_for(:user_waiter, email: "vaab")
          @user_waiter.reload
          expect(@user_waiter.email).not_to eq("vaab")
        end
        it 'render edit page' do
          patch :update, id: @user_waiter.id, user: attributes_for(:user_waiter, email: "vaab")
          expect(response).to render_template :edit
        end
      end

      context 'when params are valid' do
        it 'update specific user' do
          patch :update, id: @user_waiter.id, user: attributes_for(:user_waiter, name: "Vanja Vanjaa")
          @user_waiter.reload
          expect(@user_waiter.name).to eq("Vanja Vanjaa")
        end

        it 'renders that user page' do
          patch :update, id: @user_waiter.id, user: attributes_for(:user_waiter, name: "Vanja Vanjaa")
          @user_waiter.reload
          expect(response).to redirect_to(action: :show)
        end
      end
    end

    context 'when is manager' do
      context 'when params are not valid' do
        it 'dont update specific user' do
          patch :update, id: @user_waiter.id, user: attributes_for(:user_waiter, email: "vaab")
          @user_waiter.reload
          expect(@user_waiter.email).not_to eq("vaab")
        end
        it 'render edit page' do
          patch :update, id: @user_waiter.id, user: attributes_for(:user_waiter, email: "vaab")
          expect(response).to render_template :edit
        end
      end

      context 'when params are valid' do
        it 'update specific user' do
          patch :update, id: @user_waiter.id, user: attributes_for(:user_waiter, name: "Vanja Vanjaa")
          @user_waiter.reload
          expect(@user_waiter.name).to eq("Vanja Vanjaa")
        end

        it 'renders that user page' do
          patch :update, id: @user_waiter.id, user: attributes_for(:user_waiter, name: "Vanja Vanjaa")
          @user_waiter.reload
          expect(response).to redirect_to(action: :show)
        end
      end
    end

    context 'when is not current user' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(user)
      end
      context 'when params are not valid' do
        it 'dont update specific user' do
          patch :update, id: user, user: attributes_for(:user_waiter, email: "vaab")
          user.reload
          expect(user.email).not_to eq("vaab")
        end
        it 'dont render edit page' do
          patch :update, id: user, user: attributes_for(:user_waiter, email: "vaab")
          expect(response).not_to render_template :edit
        end
        it 'render home page' do
          patch :update, id: user, user: attributes_for(:user_waiter, email: "vaab")
          expect(response).to redirect_to root_path
        end
      end

      context 'when params are valid' do
        it 'dont update specific user' do
          patch :update, id: user, user: attributes_for(:user_waiter, email: "vaab")
          user.reload
          expect(user.email).not_to eq("vaab")
        end
        it 'dont render edit page' do
          patch :update, id: user, user: attributes_for(:user_waiter, email: "vaab")
          expect(response).not_to render_template :edit
        end
        it 'render home page' do
          patch :update, id: user, user: attributes_for(:user_waiter, email: "vaab")
          expect(response).to redirect_to root_path
        end
      end
    end

  end

end
