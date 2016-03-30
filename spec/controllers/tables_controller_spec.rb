require 'rails_helper'

RSpec.describe TablesController, type: :controller do
  include SessionsHelper
  subject(:subj_table) { Table.new(number: number) }
  let(:number) { 3 }

  context 'valid ' do
    it { expect(subj_table).to be_valid }
  end
  before do
    @manager = create(:user_waiter,manager: true, email: 'sanjica@rbt.com')
    @user_waiter = create(:user_waiter)
    subj_table.save
    log_in(@manager)
    @table = create(:table)
    @tables = [subj_table, @table]
  end
  after do
    log_out
  end

  describe 'GET #index' do

    context 'when is waiter' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(@manager)
      end
      it 'renders the index view' do
        get :index
        expect(response).to render_template :index
      end

      it 'shows all tables' do
        get :index
        expect(assigns(:tables)).to eq(@tables)
      end
    end

    context 'when is manager' do
      it 'renders the index view' do
        get :index
        expect(response).to render_template :index
      end

      it 'shows all tables' do
        get :index
        expect(assigns(:tables)).to eq(@tables)
      end
    end

    context 'when is not logged' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end

      it 'dont render the index view' do
        get :index
        expect(response).not_to render_template :index
      end

      it 'render the login view' do
        get :index
        expect(response).to redirect_to root_path
      end

      it 'dont add tables' do
        get :index
        expect(assigns(:tables)).to eq(nil)
      end
    end
  end

  describe 'GET #show' do

    context 'when is manager' do
      it 'renders the show view' do
        get :show, id: @table
        expect(response).to render_template :show
      end

      it 'shows specific menu' do
        get :show, id: @table
        expect(assigns(:table)).to eq(@table)
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
        get :show, id: @table
        expect(response).to render_template :show
      end

      it 'shows specific table' do
        get :show, id: @table
        expect(assigns(:table)).to eq(@table)
      end
    end

    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont the show view' do
        get :show, id: @table
        expect(response).not_to render_template :show
      end

      it 'dont the show view' do
        get :show, id: @table
        expect(response).to redirect_to root_path
      end

      it 'dont specific table' do
        get :show, id: @table
        expect(assigns(:table)).to eq(nil)
      end
    end
  end

  describe 'GET #new' do
    context 'when is manager' do
      it 'renders the new view' do
        get :new
        expect(response).to render_template :new
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
        get :new
        expect(response).not_to render_template :new
      end

      it 'redirect to login' do
        get :new
        expect(response).to redirect_to root_path
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
      it 'dont render new view' do
        get :new
        expect(response).not_to render_template :new
      end

      it 'redirect to login' do
        get :new
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #create' do
    before do
      @count = Table.count
      @count+=1
    end

    context 'when manager is logged in' do
      context 'when params are valid' do
        it 'creates new instance of table' do
          post :create, table: attributes_for(:table, sum:0)
          expect(Table.count).to eq(@count)
        end

        it 'assigns to variable new table' do
          post :create, table:  { number: 7, sum: 0, payment:true}
          expect(assigns(:table).number).to eq(7)
        end

        it 'show all tables' do
          post :create,  table: attributes_for(:table, sum:0)
          expect(response).to redirect_to tables_path
        end
      end
      context 'when params are not valid' do
        it 'dont create new instance of table' do
          post :create, table: { number: nil}
          expect(Table.count).not_to eq(@count)
        end

        it 'show form for new table' do
          post :create, table: { number: nil}
          expect(response).to render_template 'new'
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
      it 'dont create new instance of table' do
        post :create, table: { number: 1}
        expect(Table.count).not_to eq(@count)
      end

      it 'renders login page' do
        post :create, table: { number: 1}
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
      it 'dont create new instance of table' do
        post :create, table: { number: 1}
        expect(Table.count).not_to eq(@count)
      end

      it 'renders tables page' do
        post :create, table: { number: 1}
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #update' do

    context 'when is manager' do
      context 'when params are valid' do
        it 'update specific table' do
          patch :update, id: subj_table
          subj_table.reload
          expect(subj_table.sum).to eq(0)
        end

        it 'renders all tables' do
          patch :update, id: subj_table
          subj_table.reload
          expect(response).to redirect_to tables_path
          expect(response).to redirect_to action: :index
        end
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
      context 'when params are valid' do
        it 'update specific table' do
          patch :update, id: subj_table
          subj_table.reload
          expect(subj_table.sum).to eq(0)
        end

        it 'renders all tables' do
          patch :update, id: subj_table
          subj_table.reload
          expect(response).to redirect_to tables_path
          expect(response).to redirect_to action: :index
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
      it 'dont update specific table' do
        patch :update, id: subj_table
        subj_table.reload
        expect(subj_table.sum).not_to eq(0)
      end

      it 'renders login page' do
        patch :update, id: subj_table
        subj_table.reload
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is manager' do
      it 'delete selected table' do
        delete :destroy, id: subj_table
        expect(Table.exists?(subj_table.id)).to be_falsey
      end

      it 'expect to render all tables page' do
        delete :destroy, id: subj_table
        expect(response). to redirect_to tables_path
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
      it 'dont delete selected table' do
        delete :destroy, id: subj_table
        expect(Table.exists?(subj_table.id)).to be_truthy
      end

      it 'expect to render root page for waiter' do
        delete :destroy, id: subj_table
        expect(response). to redirect_to root_path
      end
    end
    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont delete selected table' do
        delete :destroy, id: subj_table
        expect(Table.exists?(subj_table.id)).to be_truthy
      end

      it 'expect to render login page' do
        delete :destroy, id: subj_table
        expect(response). to redirect_to root_path
      end
    end
  end
end
