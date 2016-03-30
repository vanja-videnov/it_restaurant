require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  subject(:subj_order) { Order.new(table_id: table.id, user_id: user.id)}
  let(:table) { create(:table) }
  let(:user) { create(:user_waiter)}

  it { expect(subj_order).to be_valid }
  include SessionsHelper

  before do
    @user_waiter = create(:user_waiter, email:'konobar@rbt.com')
    subj_order.save
    @user_waiter_2 = user
    @table = table
    @table_2 = create(:table, number:3)
    @manager = create(:user_waiter,manager: true, email: 'sanjica@rbt.com')
  end

  describe 'GET #new' do

    context 'when is not logged in' do
      it 'renders login form' do
        get :new, table_id:@table.id
        expect(response). to redirect_to root_path
      end
    end

    context 'when is logged in waiter' do
      before do
        log_in(@user_waiter)
        @count = Order.count
      end
      after do
        log_out
      end

      context 'when is non existing order' do
        it 'update table payment' do
          get :new, table_id:@table.id
          expect(@table.payment).to eq(false)
        end

        it 'create new order' do
          get :new, table_id:@table.id
          expect(assigns(:order).user_id).to eq(@user_waiter.id)
        end

        it 'show order page' do
          get :new, table_id:@table.id
          expect(response).to render_template :new
        end

        it 'order is created' do
          get :new, table_id:@table.id
          expect(Order.count).to eq(@count+1)
        end

      end

      context 'when is existing order' do
        before do
          log_in(@user_waiter_2)
          @count = Order.count
        end
        after do
          log_out
        end
        it 'update table payment when is new order' do
          get :new, table_id:@table_2.id
          expect(@table.payment).to eq(false)
        end

        it 'get old order' do
          get :new, table_id:@table.id
          expect(assigns(:order).user_id).to eq(@user_waiter_2.id)
        end

        it 'show order page' do
          get :new, table_id:@table.id
          expect(response).to render_template :new
        end

        it 'order is not created' do
          get :new, table_id:@table.id
          expect(Order.count).to eq(@count)
        end
      end
    end

    context 'when is logged in manager' do
      before do
        log_in(@manager)
      end
      after do
        log_out
      end
      it 'redirect to manager dashboard' do
        get :new, table_id:@table.id
        expect(response).to redirect_to manager_index_path
      end
    end
  end

  describe 'GET #index' do

    context 'when is manager' do
      before do
        log_in(@manager)
      end
      after do
        log_out
      end
      it 'renders the index view' do
        get :index, user_id:@manager
        expect(response).to redirect_to manager_index_path
      end

      it 'dont assign users' do
        get :index, user_id:@manager
        expect(assigns(:orders)).to eq(nil)
      end
    end

    context 'when is waiter' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(user)
      end
      it 'renders the index view' do
        get :index, user_id:@user_waiter
        expect(response).to render_template :index
      end

      it 'shows all users' do
        get :index, user_id:@user_waiter
        expect(assigns(:orders)).to eq(@user_waiter.orders)
      end
    end

    context 'when is not logged in' do

      it 'renders the login page' do
        get :index, user_id:@user_waiter
        expect(response).to redirect_to root_path
      end

      it 'dont assign users' do
        get :index, user_id:@user_waiter
        expect(assigns(:orders)).to eq(nil)
      end
    end
  end

  describe 'GET #show' do

    context 'when is manager' do
      before do
        log_in(@manager)
      end
      after do
        log_out
      end
      it 'show manager dashboard' do
        get :show, table_id: @table, id: user.orders.first
        expect(response).to redirect_to manager_index_path
      end

      it 'dont assing specific order' do
        get :show, table_id: @table, id: user.orders.first
        expect(assigns(:order)).to eq(nil)
      end
    end

    context 'when is waiter' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(@manager)
      end
      it 'renders the show view' do
        get :show, table_id: table, id: user.orders.first
        expect(response).to render_template :new
      end

      it 'shows specific order' do
        get :show, table_id: @table, id: user.orders.first
        expect(assigns(:order)).to eq(user.orders.first)
      end
    end

    context 'when is not logged in' do

      it 'dont the show view' do
        get :show, table_id: @table, id: user.orders.first
        expect(response).to redirect_to root_path
      end

      it 'dont assing specific order' do
        get :show, table_id: @table, id: user.orders.first
        expect(assigns(:order)).to eq(nil)
      end
    end
  end

end
