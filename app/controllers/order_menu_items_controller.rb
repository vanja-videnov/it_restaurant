class OrderMenuItemsController < ApplicationController

  def create
    @order_menu_item = OrderMenuItem.create(order_id: params[:order_id], item_id: params[:item_id])
    @sum = @order_menu_item.order.table.sum + @order_menu_item.item.price
    @order_menu_item.order.table.update_attributes(sum: @sum)
    redirect_to table_order_path(table_id:params[:table_id], id:params[:order_id])
  end
  # def destroy
  #   @order_menu_item = OrderMenuItem.find(params[:id])
  #   @order_menu_item.quantity -= 1
  #   @order_menu_item.order.table.sum -= @order_menu_item.item.price
  #   @table = @order_menu_item.order.table
  #   @table.save
  #   @order_menu_item.save
  #   if @order_menu_item.quantity == 0
  #     @order_menu_item.destroy
  #     redirect_to table_path(@table)
  #   else
  #     redirect_to table_path(@table)
  #   end
  # end

end
