class OrderMenuItemsController < ApplicationController
  before_action :is_waiter

  def create
    @order_menu_item = OrderMenuItem.find_or_create_by(item_id: params[:item_id], order_id: params[:order_id])
    @order_menu_item.update_existing
    redirect_to table_order_path(table_id: @order_menu_item.order.table_id, id: @order_menu_item.order_id)
  end

  def destroy
    @order_menu_item = OrderMenuItem.find(params[:id])
    @table = @order_menu_item.order.table

    ret = @order_menu_item.delete_and_update(params[:delete])
    if ret == 0
      redirect_to tables_path
    else
      redirect_to table_path(@table)
    end
  end

  private
  def is_waiter
    if logged_in?
      if current_user.manager?
        redirect_to manager_index_path
      end
    else
      redirect_to root_path
    end
  end
end
