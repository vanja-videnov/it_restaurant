require 'rails_helper'

RSpec.describe Manager::ItemsController, type: :controller do
  include SessionsHelper
  subject(:subj_item) { Item.new(name: name, description: description, price: price) }
  let(:name) { 'banana' }
  let(:description) { 'this is ok' }
  let(:price) { 3232 }

  context 'valid ' do
    it { expect(subj_item).to be_valid }
  end
  before do
    @manager = create(:user_waiter,manager: true, email: 'sanjica@rbt.com')
    @user_waiter = create(:user_waiter)
    @menu = create(:menu)
    @category = create(:category)
    @subcategory = create(:subcategory, category:@category)
    subj_item.subcategory = @subcategory
    subj_item.menu = @menu
    subj_item.save
    log_in(@manager)
  end
  after do
    log_out
  end
  describe 'GET #new' do
    context 'when is manager' do
      context 'when there is subcategory and category' do
        it 'renders the new view' do
          get :new, menu_id: @menu
          expect(response).to render_template :new
        end
      end
      context 'when there is no subcategory' do
        before do
          Subcategory.delete_all
        end

        after do
          @subcategory = create(:subcategory, category:@category)
          subj_item.subcategory = @subcategory
          subj_item.save
        end

        it 'shows error message' do
          get :new, menu_id: @menu
          expect(flash[:error]).to be_present
          expect(response).to redirect_to menus_path
        end
      end
      context 'when there is no category' do
        before do
          Category.delete_all
        end

        after do
          @category = create(:category)
          @subcategory.category = @category
          subj_item.subcategory = @subcategory
          subj_item.save
        end

        it 'shows error message' do
          get :new, menu_id: @menu
          expect(flash[:error]).to be_present
          expect(response).to redirect_to menus_path
        end
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
        get :new, menu_id: @menu
        expect(response).not_to render_template :new
      end
    end
  end

  describe 'POST #create' do
    before do
      @count = Item.count
      @count+=1
    end

    context 'when manager is logged in' do
      context 'when params are valid' do
        it 'creates new instance of item' do
          post :create, menu_id: @menu, item: attributes_for(:item_pasta, subcategory: @subcategory)
          expect(Item.count).to eq(@count)
        end

        it 'show root path' do
          post :create, menu_id: @menu, item: attributes_for(:item_pasta, subcategory: @subcategory)
          expect(response).to redirect_to edit_manager_menu_path(id: @menu)
        end
      end
      context 'when params are not valid' do
        it 'dont create new instance of category' do
          post :create, menu_id: @menu, item: attributes_for(:item_pasta, name: '', subcategory: @subcategory)
          expect(Item.count).not_to eq(@count)
        end

        it 'dont show root path' do
          post :create, menu_id: @menu, item: attributes_for(:item_pasta, name: '', subcategory: @subcategory)
          expect(response).not_to redirect_to menus_path
        end

        it 'show new form' do
          post :create, menu_id: @menu, item: attributes_for(:item_pasta, name: '', subcategory: @subcategory)
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
        post :create, menu_id: @menu, item: attributes_for(:item_pasta, subcategory: @subcategory)
        expect(Item.count).not_to eq(@count)
      end

      it 'dont renders form again' do
        post :create, menu_id: @menu, item: attributes_for(:item_pasta, subcategory: @subcategory)
        expect(response).not_to render_template :new
      end

      it 'renders login page' do
        post :create, menu_id: @menu, item: attributes_for(:item_pasta, subcategory: @subcategory)
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
        post :create, menu_id: @menu, item: attributes_for(:item_pasta, subcategory: @subcategory)
        expect(Item.count).not_to eq(@count)
      end

      it 'dont renders form again' do
        post :create, menu_id: @menu, item: attributes_for(:item_pasta, subcategory: @subcategory)
        expect(response).not_to render_template :new
      end

      it 'renders login page' do
        post :create, menu_id: @menu, item: attributes_for(:item_pasta, subcategory: @subcategory)
        expect(response).to redirect_to root_path
      end
    end

  end

  describe 'GET #edit' do

    context 'when is manager' do
      it 'renders the edit view' do
        get :edit, id: subj_item, menu_id: @menu
        expect(response).to render_template :edit
      end

      it 'shows specific category' do
        get :edit, id: subj_item, menu_id: @menu
        expect(assigns(:item)).to eq(subj_item)
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
        get :edit, id: subj_item, menu_id: @menu
        expect(response).not_to render_template :edit
      end

      it 'dont shows specific item' do
        get :edit, id: subj_item, menu_id: @menu
        expect(assigns(:item)).not_to eq(subj_item)
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
        get :edit, id: subj_item, menu_id: @menu
        expect(response).not_to render_template :edit
      end

      it 'dont shows specific item' do
        get :edit, id: subj_item, menu_id: @menu
        expect(assigns(:item)).not_to eq(subj_item)
      end
    end
  end

  describe 'PATCH #update' do

    context 'when is manager' do
      context 'when params are valid' do
        it 'update specific item' do
          patch :update, id: subj_item, menu_id: @menu, item: attributes_for(:item, name: 'fish', subcategory: @subcategory)
          subj_item.reload
          expect(subj_item.name).to eq('fish')
        end

        it 'renders that item page' do
          patch :update, id: subj_item, menu_id: @menu, item: attributes_for(:item, name: 'fish', subcategory: @subcategory)
          subj_item.reload
          expect(response).to redirect_to edit_manager_menu_path(id: @menu)
        end
      end
      context 'when params are not valid' do
        it 'dont update specific item' do
          patch :update, id: subj_item, menu_id: @menu, item: attributes_for(:item, name: '', subcategory: @subcategory)
          subj_item.reload
          expect(subj_item.name).not_to eq('')
        end

        it 'renders that item page' do
          patch :update, id: subj_item, menu_id: @menu, item: attributes_for(:item, name: '', subcategory: @subcategory)
          subj_item.reload
          expect(response).not_to redirect_to manager_menu_path(id: @menu)
        end

        it 'renders edit item page' do
          patch :update, id: subj_item, menu_id: @menu, item: attributes_for(:item, name: '', subcategory: @subcategory)
          subj_item.reload
          expect(response).to redirect_to action: :edit
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
      it 'dont update specific item' do
        patch :update, id: subj_item, menu_id: @menu, item: attributes_for(:item, name: 'pizzza', subcategory: @subcategory)
        subj_item.reload
        expect(subj_item.name).not_to eq('pizzza')
      end

      it 'renders root page' do
        patch :update, id: subj_item, menu_id: @menu, item: attributes_for(:item, name: '', subcategory: @subcategory)
        subj_item.reload
        expect(response).to redirect_to root_path
      end
    end

    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont update specific item' do
        patch :update, id: subj_item, menu_id: @menu, item: attributes_for(:item, name: 'pizzza', subcategory: @subcategory)
        subj_item.reload
        expect(subj_item.name).not_to eq('pizzza')
      end

      it 'renders root page' do
        patch :update, id: subj_item, menu_id: @menu, item: attributes_for(:item, name: '', subcategory: @subcategory)
        subj_item.reload
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is manager' do
      it 'delete selected item' do
        delete :destroy,menu_id: @menu, id: subj_item
        expect(Item.exists?(subj_item.id)).to be_falsey
      end

      it 'expect to render index page' do
        delete :destroy,menu_id: @menu, id: subj_item
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
      it 'dont delete selected item' do
        delete :destroy,menu_id: @menu, id: subj_item
        expect(Item.exists?(subj_item.id)).not_to be_falsey
      end
    end
    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont delete selected item' do
        delete :destroy,menu_id: @menu, id: subj_item
        expect(Item.exists?(subj_item.id)).not_to be_falsey
      end
    end
  end

end
