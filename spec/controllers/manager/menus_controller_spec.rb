require 'rails_helper'

RSpec.describe Manager::MenusController, type: :controller do
  include SessionsHelper
  subject(:sub_menu) { Menu.new(date: date)}
  let(:date) { '2016-03-03' }

  before do
    @manager = create(:user_waiter,manager: true, email: 'sanjica@rbt.com')
    @user_waiter = create(:user_waiter)
    log_in(@manager)
    @menu = create(:menu)
    @menu_easter = create(:menu_easter)
  end
  after do
    log_out
  end

  describe 'GET #new' do
    context 'when is manager' do
      it 'renders the new view' do
        get :new
        expect(response).to render_template :new
      end
    end

    context 'when is not manager' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont render new view' do
        get :new
        expect(response).not_to render_template :new
      end
    end
  end

  describe 'POST #create' do
    before do
      @count = Menu.count
      @count+=1
    end

    context 'when manager is logged in' do
      it 'creates new instance of menu' do
        post :create, menu: attributes_for(:menu, date: '2015-03-03')
        expect(Menu.count).to eq(@count)
      end

      it 'show root path' do
        post :create,  menu: attributes_for(:menu, date: '2015-03-03')
        expect(response).to redirect_to menus_path
      end
    end

    context 'when user is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont create new instance of menu' do
        post :create, menu: attributes_for(:menu, date: '2015-03-03')
        expect(Menu.count).not_to eq(@count)
      end

      it 'renders form again' do
        post :create, menu: attributes_for(:menu, date: '2015-03-03')
        expect(response).not_to render_template :new
      end

      it 'renders login page' do
        post :create, menu: attributes_for(:menu, date: '2015-03-03')
        expect(response).to redirect_to root_path
      end
    end

    context 'when user is waiter' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(@manager)
      end
      it 'dont create new instance of menu' do
        post :create, menu: attributes_for(:menu, date: '2015-03-03')
        expect(Menu.count).not_to eq(@count)
      end

      it 'renders form again' do
        post :create, menu: attributes_for(:menu, date: '2015-03-03')
        expect(response).not_to render_template :new
      end

      it 'renders login page' do
        post :create, menu: attributes_for(:menu, date: '2015-03-03')
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #edit' do

    context 'when is manager' do
      it 'renders the edit view' do
        get :edit, id: @menu
        expect(response).to render_template :edit
      end

      it 'shows specific menu' do
        get :edit, id: @menu
        expect(assigns(:menu)).to eq(@menu)
      end
    end

    context 'when is not manager' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont renders the edit view' do
        get :edit, id: @menu
        expect(response).not_to render_template :edit
      end

      it 'dont shows specific menu' do
        get :edit, id: @menu
        expect(assigns(:menu)).not_to eq(@menu)
      end
    end
  end

  describe 'PATCH #update' do

    context 'when is manager' do
      context 'when params are valid' do
        it 'update specific menu' do
          patch :update, id: @menu, menu: attributes_for(:menu, date: '2011-03-03')
          @menu.reload
          expect(@menu.date).to eq(Date.parse('2011-03-03'))
        end

        it 'renders that menu page' do
          patch :update, id: @menu, menu: attributes_for(:menu, date: '2011-03-03')
          @menu.reload
          expect(response).to redirect_to menu_path(id: @menu)
        end
      end
    end

    context 'when logged user is not manager' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(@manager)
      end
      context 'when params are valid' do
        it 'dont update specific menu' do
          patch :update, id: @menu, menu: attributes_for(:menu, date: '2011-03-03')
          @menu.reload
          expect(@menu.date).not_to eq(Date.parse('2011-03-03'))
        end

        it 'dont renders that menu page' do
          patch :update, id: @menu, menu: attributes_for(:menu, date: '2011-03-03')
          @menu.reload
          expect(response).not_to redirect_to menu_path(id: @menu)
        end
      end
    end

    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      context 'when params are valid' do
        it 'dont update specific menu' do
          patch :update, id: @menu, menu: attributes_for(:menu, date: '2011-03-03')
          @menu.reload
          expect(@menu.date).not_to eq(Date.parse('2011-03-03'))
        end

        it 'dont renders that menu page' do
          patch :update, id: @menu, menu: attributes_for(:menu, date: '2011-03-03')
          @menu.reload
          expect(response).not_to redirect_to menu_path(id: @menu)
        end
      end
    end

  end

  describe 'DELETE #destroy' do
    context 'when is manager' do
      it 'delete selected menu' do
        delete :destroy, id: @menu
        expect(Menu.exists?(@menu.id)).to be_falsey
      end

      it 'expect to render index page' do
        delete :destroy, id: @menu
        expect(response). to redirect_to menus_path
      end
    end
    context 'when is not manager' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(@manager)
      end
      it 'dont delete selected menu' do
        delete :destroy, id: @menu
        expect(Menu.exists?(@menu.id)).not_to be_falsey
      end

    end

  end
end
