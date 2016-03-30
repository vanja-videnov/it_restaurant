require 'rails_helper'

RSpec.describe MenusController, type: :controller do
  include SessionsHelper
  before do
    @menu = create(:menu)
    @menu_easter = create(:menu_easter)
    @categories = [create(:category)]
    @subcategories = [create(:subcategory)]
    @menus = [@menu, @menu_easter]
  end
  describe 'GET #index' do

    context 'when is not manager' do
      before do
        log_in(create(:user_waiter))
      end
      after do
        log_out
      end
      it 'renders the index view' do
        get :index
        expect(response).to render_template :index
      end

      it 'shows all menus' do
        get :index
        expect(assigns(:menus)).to eq(@menus)
      end

      it 'shows all categories' do
        get :index
        expect(assigns(:categories)).to eq(@categories)
      end

      it 'shows all subcategories' do
        get :index
        expect(assigns(:subcategories)).to eq(@subcategories)
      end
    end

    context 'when is manager' do
      before do
        log_in(create(:user_waiter,manager: true))
      end
      after do
        log_out
      end
      it 'renders the index view' do
        get :index
        expect(response).to render_template :index
      end

      it 'shows all menus' do
        get :index
        expect(assigns(:menus)).to eq(@menus)
      end

      it 'shows all categories' do
        get :index
        expect(assigns(:categories)).to eq(@categories)
      end

      it 'shows all subcategories' do
        get :index
        expect(assigns(:subcategories)).to eq(@subcategories)
      end
    end

    context 'when is not logged' do

      it 'dont render the index view' do
        get :index
        expect(response).not_to render_template :index
      end

      it 'render the login view' do
        get :index
        expect(response).to redirect_to root_path
      end

      it 'dont show menus' do
        get :index
        expect(assigns(:menus)).not_to eq(@menus)
      end

      it 'dont show menus' do
        get :index
        expect(assigns(:menus)).to eq(nil)
      end

      it 'dont show all categories' do
        get :index
        expect(assigns(:categories)).not_to eq(@categories)
      end

      it 'dont show all subcategories' do
        get :index
        expect(assigns(:subcategories)).not_to eq(@subcategories)
      end
    end
  end

  describe 'GET #show' do

    context 'when is manager' do
      before do
        log_in(create(:user_waiter,manager: true))
      end
      after do
        log_out
      end
      it 'renders the show view' do
        get :show, id: @menu
        expect(response).to render_template :show
      end

      it 'shows specific menu' do
        get :show, id: @menu
        expect(assigns(:menu)).to eq(@menu)
      end
    end

    context 'when is not manager' do
      before do
        log_in(create(:user_waiter))
      end
      after do
        log_out
      end
      it 'renders the show view' do
        get :show, id: @menu
        expect(response).to render_template :show
      end

      it 'shows specific menu' do
        get :show, id: @menu
        expect(assigns(:menu)).to eq(@menu)
      end
    end

    context 'when is not logged in' do

      it 'dont the show view' do
        get :show, id: @menu
        expect(response).not_to render_template :show
      end

      it 'dont the show view' do
        get :show, id: @menu
        expect(response).to redirect_to root_path
      end

      it 'dont specific menu' do
        get :show, id: @menu
        expect(assigns(:menu)).to eq(nil)
      end
    end
  end
end
