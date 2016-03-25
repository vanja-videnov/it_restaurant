require 'rails_helper'

RSpec.describe Manager::CategoriesController, type: :controller do
  include SessionsHelper
  subject(:subj_category) { Category.new(name: name)}
  let(:name) { 'food' }

  before do
    subj_category.save
    @manager = create(:user_waiter,manager: true, email: 'sanjica@rbt.com')
    @user_waiter = create(:user_waiter)
    log_in(@manager)
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

  describe 'GET #show' do

    context 'when is manager' do
      it 'renders the show view' do
        get :show, id: subj_category
        expect(response).to render_template :show
      end

      it 'shows specific category' do
        get :show, id: subj_category
        expect(assigns(:category)).to eq(subj_category)
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
      it 'dont render the show view' do
        get :show, id: subj_category
        expect(response).not_to render_template :show
      end

      it 'dont shows specific category' do
        get :show, id: subj_category
        expect(assigns(:category)).not_to eq(subj_category)
      end
    end

    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont render the show view' do
        get :show, id: subj_category
        expect(response).not_to render_template :show
      end

      it 'dont shows specific category' do
        get :show, id: subj_category
        expect(assigns(:category)).not_to eq(subj_category)
      end
    end
  end

  describe 'POST #create' do
    before do
      @count = Category.count
      @count+=1
    end

    context 'when manager is logged in' do
      context 'when params are valid' do
        it 'creates new instance of category' do
          post :create, category: attributes_for(:category)
          expect(Category.count).to eq(@count)
        end

        it 'show root path' do
          post :create, category: attributes_for(:category)
          expect(response).to redirect_to menus_path
        end
      end
      context 'when params are not valid' do
        it 'dont create new instance of category' do
          post :create, category: attributes_for(:category, name: '')
          expect(Category.count).not_to eq(@count)
        end

        it 'dont show root path' do
          post :create, category: attributes_for(:category, name: '')
          expect(response).not_to redirect_to menus_path
        end

        it 'show new form' do
          post :create, category: attributes_for(:category, name: '')
          expect(response).to render_template :new
        end
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
        post :create, category: attributes_for(:category)
        expect(Category.count).not_to eq(@count)
      end

      it 'dont renders form again' do
        post :create, category: attributes_for(:category)
        expect(response).not_to render_template :new
      end

      it 'renders login page' do
        post :create, category: attributes_for(:category)
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
        post :create, category: attributes_for(:category)
        expect(Category.count).not_to eq(@count)
      end

      it 'dont renders form again' do
        post :create, category: attributes_for(:category)
        expect(response).not_to render_template :new
      end

      it 'renders login page' do
        post :create, category: attributes_for(:category)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #edit' do

    context 'when is manager' do
      it 'renders the edit view' do
        get :edit, id: subj_category
        expect(response).to render_template :edit
      end

      it 'shows specific category' do
        get :edit, id: subj_category
        expect(assigns(:category)).to eq(subj_category)
      end
    end

    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont renders the edit view' do
        get :edit, id: subj_category
        expect(response).not_to render_template :edit
      end

      it 'dont shows specific category' do
        get :edit, id: subj_category
        expect(assigns(:category)).not_to eq(subj_category)
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
      it 'dont renders the edit view' do
        get :edit, id: subj_category
        expect(response).not_to render_template :edit
      end

      it 'dont shows specific category' do
        get :edit, id: subj_category
        expect(assigns(:category)).not_to eq(subj_category)
      end
    end
  end

  describe 'PATCH #update' do

    context 'when is manager' do
      context 'when params are valid' do
          it 'update specific category' do
            patch :update, id: subj_category, category: attributes_for(:category, name: 'fish')
            subj_category.reload
            expect(subj_category.name).to eq('fish')
          end

          it 'renders that category page' do
            patch :update, id: subj_category, category: attributes_for(:category, name: 'fish')
            subj_category.reload
            expect(response).to redirect_to manager_category_path(id: subj_category)
          end
      end
      context 'when params are not valid' do
        it 'dont update specific category' do
          patch :update, id: subj_category, category: attributes_for(:category, name: '')
          subj_category.reload
          expect(subj_category.name).not_to eq('fish')
        end

        it 'dont renders that category page' do
          patch :update, id: subj_category, category: attributes_for(:category, name: '')
          subj_category.reload
          expect(response).not_to redirect_to manager_category_path(id: subj_category)
        end

        it 'renders edit category page' do
          patch :update, id: subj_category, category: attributes_for(:category, name: '')
          subj_category.reload
          expect(response).to render_template :edit
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
        it 'dont update specific category' do
          patch :update, id: subj_category, category: attributes_for(:category, name: 'fish')
          subj_category.reload
          expect(subj_category.name).not_to eq('fish')
        end

        it 'dont renders that category page' do
          patch :update, id: subj_category, category: attributes_for(:category, name: 'fish')
          subj_category.reload
          expect(response).not_to redirect_to manager_category_path(id: subj_category)
        end
    end

    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
        it 'dont update specific category' do
          patch :update, id: subj_category, category: attributes_for(:category, name: 'fish')
          subj_category.reload
          expect(subj_category.name).not_to eq('fish')
        end

        it 'dont renders that category page' do
          patch :update, id: subj_category, category: attributes_for(:category, name: 'fish')
          subj_category.reload
          expect(response).not_to redirect_to manager_category_path(id: subj_category)
        end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is manager' do
      it 'delete selected category' do
        delete :destroy, id: subj_category
        expect(Category.exists?(subj_category.id)).to be_falsey
      end

      it 'expect to render index page' do
        delete :destroy, id: subj_category
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
      it 'dont delete selected category' do
        delete :destroy, id: subj_category
        expect(Category.exists?(subj_category.id)).not_to be_falsey
      end
    end
    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont delete selected category' do
        delete :destroy, id: subj_category
        expect(Category.exists?(subj_category.id)).not_to be_falsey
      end
    end
  end
end
