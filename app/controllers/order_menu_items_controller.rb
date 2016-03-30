class OrderMenuItemsController < ApplicationController
  before_action :is_waiter

  def create
    @order = Order.find(params[:order_id])
    @item = Item.find(params[:item_id])
    @order_menu_item = OrderMenuItem.find_by(item_id:@item.id, order_id:@order.id)
    if @order_menu_item
      OrderMenuItem.update_existing(@order_menu_item)
      redirect_to table_order_path(table_id: @order.table.id, id: @order.id)
    else
      OrderMenuItem.create_new(@order, @item)
      redirect_to table_order_path(table_id:@order.table, id:@order.id)
    end
  end

  def destroy
    @order_menu_item = OrderMenuItem.find(params[:id])
    if params[:delete] == 'true'
      Report.destroy_if_exist(@order_menu_item.item.id, @order_menu_item.order.table.id)
    end
    @order_menu_item = OrderMenuItem.delete_and_update(@order_menu_item)
    @table = @order_menu_item.order.table
    if @order_menu_item.quantity == 0
      if @table.sum == 0
        @table.empty
        redirect_to tables_path
      else
        @order_menu_item.destroy
        redirect_to table_path(@table)
      end
    else
      redirect_to table_path(@table)
    end
  end

  private
  def is_waiter
    if logged_in?
      unless !current_user.manager?
        redirect_to manager_index_path
      end
    else
      redirect_to root_path
    end
  end
end
