require 'rails_helper'

RSpec.describe OrderMenuItemsController, type: :controller do
  subject(:subj_omi) { OrderMenuItem.new(item_id:item.id, order_id:order.id, quantity: 1)}
  let(:table) { create(:table, sum:0) }
  let(:user) { create(:user_waiter)}
  let(:order) { create(:order, table: table)}
  let(:category) { create(:category)}
  let(:subcategory) { create(:subcategory, category: category)}
  let(:item) { create(:item, subcategory: subcategory)}

  it { expect(subj_omi).to be_valid }
  include SessionsHelper

  before do
    @user_waiter = create(:user_waiter, email:'konobar@rbt.com')
    subj_omi.save
    subj_omi.order.table.update(sum: item.price)
    @item_2 = create(:item,subcategory: subcategory, name: 'vitamin')

    @user_waiter_2 = user
    @manager = create(:user_waiter,manager: true, email: 'sanjica@rbt.com')
  end

  describe 'POST #create' do
    before do
      @count = OrderMenuItem.count
    end

    context 'when manager is logged in' do
      before do
        log_in(@manager)
      end
      after do
        log_out
      end
      context 'when params are valid' do
        it 'dont create new instance of order_item' do
          post :create, table_id:table.id, order_id:order.id, item_id:item.id
          expect(OrderMenuItem.count).to eq(@count)
        end

        it 'show manager dashboard' do
          post :create, table_id:table.id, order_id:order.id, item_id:item.id
          expect(response).to redirect_to manager_index_path
        end
      end
      context 'when params are not valid' do
        it 'dont create new instance of order_item' do
          post :create, table_id:table.id, order_id:order.id, item_id:33
          expect(OrderMenuItem.count).to eq(@count)
        end

        it 'show manager dashboard' do
          post :create, table_id:table.id, order_id:order.id, item_id:33
          expect(response).to redirect_to manager_index_path
        end
      end
    end

    context 'when user is not logged in' do
      it 'dont create new instance of order_item' do
        post :create, table_id:table.id, order_id:order.id, item_id:item.id
        expect(OrderMenuItem.count).to eq(@count)
      end

      it 'show login page' do
        post :create, table_id:table.id, order_id:order.id, item_id:item.id
        expect(response).to redirect_to root_path
      end
    end

    context 'when user is waiter' do
      before do
        log_in(@user_waiter)
        @quantity = subj_omi.quantity
        @sum = subj_omi.order.table.sum
        @number_of_reports = Report.count
        @number_of_omi = OrderMenuItem.count
      end
      after do
        log_out
      end
      context 'when that order item already exist' do
        it 'updates count of that order_item' do
          post :create, table_id:table, order_id:order, item_id:item
          expect(assigns(:item)).to eq(item)
          expect(assigns(:order)).to eq(order)
          expect(assigns(:order_menu_item)).to eq(subj_omi)
          subj_omi.reload
          expect(assigns(:order_menu_item).quantity).to eq(@quantity+1)
        end

        it 'updates sum for table' do
          post :create, table_id:table.id, order_id:order.id, item_id:item.id
          subj_omi.reload
          expect(subj_omi.order.table.sum).to eq(@sum+item.price)
        end

        it 'redirect to table-order path' do
          post :create, table_id:table.id, order_id:order.id, item_id:item.id
          expect(response).to redirect_to table_order_path(table_id: table, id: order)
        end

        it 'creates new report' do
          post :create, table_id:table.id, order_id:order.id, item_id:item.id
          expect(Report.count).to eq(@number_of_reports+1)
        end
      end

      context 'when that order item dont exist' do
        it 'creates new order-item' do
          post :create, table_id:table, order_id:order, item_id: @item_2
          expect(assigns(:item)).to eq(@item_2)
          expect(assigns(:order)).to eq(order)
          subj_omi.reload
          expect(assigns(:order_menu_item)).to eq(nil)
          expect(OrderMenuItem.count).to eq(@number_of_omi+1)
        end

        it 'updates table sum for new-order' do
          post :create, table_id:table, order_id:order, item_id:@item_2
          subj_omi.reload
          expect(subj_omi.order.table.sum).to eq(@item_2.price+@sum)
        end

        it 'redirect to table-order path' do
          post :create, table_id:table.id, order_id:order.id, item_id:@item_2
          expect(response).to redirect_to table_order_path(table_id: table, id: order)
        end

        it 'creates new report' do
          post :create, table_id:table.id, order_id:order.id, item_id:@item_2
          expect(Report.count).to eq(@number_of_reports+1)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is waiter' do
      before do
        log_in(@user_waiter)
      end
      after do
        log_out
      end
      context 'when is pay' do
        it 'delete selected order-item' do
          delete :destroy, table_id: table.id, order_id: order.id, delete:'false', id: subj_omi.id
          expect(OrderMenuItem.exists?(subj_omi.id)).to be_falsey
          expect(assigns(:table).sum).to eq(0)
          expect(assigns(:table).payment).to eq(true)
        end

        it 'expect to render index page' do
          delete :destroy, table_id:table.id, order_id:order.id, delete:'false', id: subj_omi.id
          expect(response). to redirect_to tables_path
        end

        context 'when there is more order of that item' do
          before do
            subj_omi.quantity+=1
            subj_omi.save
          end
          it 'decrement number of orders for that item' do
            delete :destroy, table_id: table.id, order_id: order.id, delete:'false', id: subj_omi.id
            expect(response). to redirect_to table_path(id: table.id)
          end
        end
        context 'when there is more order on that table' do
          before do
            subj_omi.order.table.sum+=10
            subj_omi.order.table.save
          end
          it 'decrement sum on table' do
            delete :destroy, table_id: table.id, order_id: order.id, delete:'false', id: subj_omi.id
            expect(OrderMenuItem.exists?(subj_omi.id)).to be_falsey
            expect(response). to redirect_to table_path(id: table.id)
          end
        end
      end
      context 'when is delete' do
        before do
          @report = create(:report, item_id: subj_omi.item.id, table_id: subj_omi.order.table.id)
        end
        it 'delete selected order-item' do
          delete :destroy, table_id: table.id, order_id: order.id, delete:'true', id: subj_omi.id
          expect(OrderMenuItem.exists?(subj_omi.id)).to be_falsey
          expect(assigns(:table).sum).to eq(0)
          expect(assigns(:table).payment).to eq(true)
        end

        it 'expect to render index page' do
          delete :destroy, table_id:table.id, order_id:order.id, delete:'true', id: subj_omi.id
          expect(response). to redirect_to tables_path
        end

        context 'when there is more order of that item' do
          before do
            subj_omi.quantity+=1
            subj_omi.save
          end
          it 'decrement number of orders for that item' do
            delete :destroy, table_id: table.id, order_id: order.id, delete:'true', id: subj_omi.id
            expect(response). to redirect_to table_path(id: table.id)
          end
        end
      end

    end
    context 'when is manager' do
      before do
        log_in(@manager)
      end
      after do
        log_out
      end
      it 'show manager dashboard' do
        delete :destroy, table_id: table.id, order_id: order.id, delete:'false', id: subj_omi.id
        expect(response). to redirect_to manager_index_path
      end

    end

  end
end
