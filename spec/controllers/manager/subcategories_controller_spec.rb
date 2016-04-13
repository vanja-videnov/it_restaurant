require 'rails_helper'

RSpec.describe Manager::SubcategoriesController, type: :controller do
  include SessionsHelper
  subject(:subj_subcategory) { Subcategory.new(name: name)}
  let(:name) { 'fruits juices' }

  before do
    @manager = create(:user_waiter,manager: true, email: 'sanjica@rbt.com')
    @user_waiter = create(:user_waiter)
    @category = create(:category)
    subj_subcategory.category = @category
    subj_subcategory.save
    log_in(@manager)
  end
  after do
    log_out
  end

  describe 'GET #new' do
    context 'when is manager' do
      context 'when at least one category exist' do
        it 'renders the new view' do
          get :new, category_id: @category
          expect(response).to render_template :new
        end
      end

      context 'when there are no categories' do
        before do
          Category.delete_all
        end

        after do
          @category = create(:category)
          subj_subcategory.category = @category
          subj_subcategory.save
        end

        it 'shows error message' do
          get :new, category_id: @category
          expect(flash[:error]).to be_present
          expect(response).to redirect_to menus_path
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
      it 'dont render new view' do
        get :new, category_id: @category
        expect(response).not_to render_template :new
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
      it 'dont render new view' do
        get :new, category_id: @category
        expect(response).not_to render_template :new
      end
    end
  end

  describe 'POST #create' do
    before do
      @count = Subcategory.count
      @count+=1
    end

    context 'when manager is logged in' do
      context 'when params are valid' do
        it 'creates new instance of subcategory' do
          post :create, category_id: @category, subcategory: attributes_for(:subcategory)
          expect(Subcategory.count).to eq(@count)
        end

        it 'show root path' do
          post :create, category_id: @category, subcategory: attributes_for(:subcategory)
          expect(response).to redirect_to menus_path
        end
      end
      context 'when params are not valid' do
        it 'dont create new instance of sub' do
          post :create, category_id: @category, subcategory: attributes_for(:subcategory, name: '')
          expect(Subcategory.count).not_to eq(@count)
        end

        it 'dont show root path' do
          post :create, category_id: @category, subcategory: attributes_for(:subcategory, name: '')
          expect(response).not_to redirect_to menus_path
        end

        it 'show new form' do
          post :create, category_id: @category, subcategory: attributes_for(:subcategory, name: '')
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
      it 'dont create new instance of subcategory' do
        post :create, category_id: @category, subcategory: attributes_for(:subcategory)
        expect(Subcategory.count).not_to eq(@count)
      end

      it 'dont renders form again' do
        post :create, category_id: @category, subcategory: attributes_for(:subcategory)
        expect(response).not_to redirect_to manager_category_path(id: @category)
      end

      it 'renders login page' do
        post :create, category_id: @category, subcategory: attributes_for(:subcategory)
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
      it 'dont create new instance of subcategory' do
        post :create, category_id: @category, subcategory: attributes_for(:subcategory)
        expect(Subcategory.count).not_to eq(@count)
      end

      it 'dont renders form again' do
        post :create, category_id: @category, subcategory: attributes_for(:subcategory)
        expect(response).not_to render_template :new
      end

      it 'renders login page' do
        post :create, category_id: @category, subcategory: attributes_for(:subcategory)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #edit' do

    context 'when is manager' do
      it 'renders the edit view' do
        get :edit, category_id: @category,id: subj_subcategory
        expect(response).to render_template :edit
      end

      it 'shows specific subcategory' do
        get :edit,category_id: @category, id: subj_subcategory
        expect(assigns(:subcategory)).to eq(subj_subcategory)
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
        get :edit, category_id: @category,id: subj_subcategory
        expect(response).not_to render_template :edit
      end

      it 'dont shows specific subcategory' do
        get :edit, category_id: @category,id: subj_subcategory
        expect(assigns(:subcategory)).not_to eq(subj_subcategory)
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
        get :edit, category_id: @category,id: subj_subcategory
        expect(response).not_to render_template :edit
      end

      it 'dont shows specific subcategory' do
        get :edit, category_id: @category,id: subj_subcategory
        expect(assigns(:subcategory)).not_to eq(subj_subcategory)
      end
    end
  end

  describe 'PATCH #update' do

    context 'when is manager' do
      context 'when params are valid' do
        it 'update specific subcategory' do
          patch :update, id: subj_subcategory,category_id:@category, subcategory: attributes_for(:subcategory, name: 'fish')
          subj_subcategory.reload
          expect(subj_subcategory.name).to eq('fish')
        end

        it 'renders that subcategory page' do
          patch :update, id: subj_subcategory,category_id: @category, subcategory: attributes_for(:subcategory, name: 'fish')
          subj_subcategory.reload
          expect(response).to redirect_to manager_category_path(id: subj_subcategory)
        end
      end
      context 'when params are not valid' do
        it 'dont update specific subcategory' do
          patch :update, id: subj_subcategory,category_id:@category, subcategory: attributes_for(:subcategory, name: '')
          subj_subcategory.reload
          expect(subj_subcategory.name).not_to eq('fish')
        end

        it 'renders that subcategory page' do
          patch :update, id: subj_subcategory,category_id: @category, subcategory: attributes_for(:subcategory, name: '')
          subj_subcategory.reload
          expect(response).not_to redirect_to manager_category_path(id: subj_subcategory)
        end

        it 'renders edit subcategory page' do
          patch :update, id: subj_subcategory,category_id: @category, subcategory: attributes_for(:subcategory, name: '')
          subj_subcategory.reload
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
        patch :update, id: subj_subcategory,category_id:@category, subcategory: attributes_for(:subcategory, name: 'fish')
        subj_subcategory.reload
        expect(subj_subcategory.name).not_to eq('fish')
      end

      it 'dont renders that category page' do
        patch :update, id: subj_subcategory,category_id:@category, subcategory: attributes_for(:subcategory, name: 'fish')
        subj_subcategory.reload
        expect(response).not_to redirect_to manager_category_path(id: subj_subcategory)
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
        patch :update, id: subj_subcategory,category_id:@category, subcategory: attributes_for(:subcategory, name: 'fish')
        subj_subcategory.reload
        expect(subj_subcategory.name).not_to eq('fish')
      end

      it 'dont renders that category page' do
        patch :update, id: subj_subcategory,category_id:@category, subcategory: attributes_for(:subcategory, name: 'fish')
        subj_subcategory.reload
        expect(response).not_to redirect_to manager_category_path(id: subj_subcategory)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is manager' do
      it 'delete selected category' do
        delete :destroy,category_id: @category, id: subj_subcategory
        expect(Subcategory.exists?(subj_subcategory.id)).to be_falsey
      end

      it 'expect to render index page' do
        delete :destroy,category_id: @category, id: subj_subcategory
        expect(response). to redirect_to manager_category_path(id: @category)
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
        delete :destroy,category_id: @category, id: subj_subcategory
        expect(Subcategory.exists?(subj_subcategory.id)).not_to be_falsey
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
        delete :destroy,category_id: @category, id: subj_subcategory
        expect(Subcategory.exists?(subj_subcategory.id)).not_to be_falsey
      end
    end
  end
end
