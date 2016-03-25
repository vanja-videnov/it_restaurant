class OrderMenuItemsController < ApplicationController

  def create
    @order_menu_item = OrderMenuItem.new
    @table = Table.find(params[:table_id])
    @order = Order.find(params[:order_id])
    @item = Item.find(params[:item_id])
    if OrderMenuItem.find_by(item_id:params[:item_id], order_id:@order.id).present?
      @order_menu_item = OrderMenuItem.find_by(item_id:@item.id, order_id:@order.id)
      @order_menu_item.quantity += 1
      @order_menu_item.save
      @sum = @table.sum + @order_menu_item.item.price
      @table.update_attributes(sum: @sum)
      redirect_to table_order_path(table_id:params[:table_id], id:params[:order_id])
    else
      @order_menu_item = OrderMenuItem.create(order_id: @order.id, item_id: @item.id, quantity: 1)
      @sum = @table.sum + @order_menu_item.item.price
      @table.update_attributes(sum: @sum)
      redirect_to table_order_path(table_id:@table, id:@order)
    end
  end
  def destroy
    @order_menu_item = OrderMenuItem.find(params[:id])
    @order_menu_item.quantity -= 1
    @order_menu_item.order.table.sum -= @order_menu_item.item.price
    @table = @order_menu_item.order.table
    @table.save
    @order_menu_item.save
    if @order_menu_item.quantity == 0
      if @table.sum == 0
        @table.payment = true
        @table.orders.destroy_all
        @table.save
        redirect_to tables_path
      else
        @order_menu_item.destroy
        redirect_to table_path(@table)
      end
    else
      redirect_to table_path(@table)
    end
  end

end
