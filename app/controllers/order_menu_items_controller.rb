class OrderMenuItemsController < ApplicationController
  before_action :is_waiter

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
      Report.create(date: Date.today.to_s, table_id:@table.id, category_id:@item.subcategory.category.id, subcategory_id: @item.subcategory.id, item_id:@item.id)
      redirect_to table_order_path(table_id:params[:table_id], id:params[:order_id])
    else
      @order_menu_item = OrderMenuItem.create(order_id: @order.id, item_id: @item.id, quantity: 1)
      @sum = @table.sum + @order_menu_item.item.price
      @table.update_attributes(sum: @sum)
      Report.create(date: Date.today.to_s, table_id:@table.id, category_id:@item.subcategory.category.id, subcategory_id: @item.subcategory.id, item_id:@item.id)
      redirect_to table_order_path(table_id:@table, id:@order)
    end
  end
  def destroy

    @order_menu_item = OrderMenuItem.find(params[:id])
    if params[:delete] == 'true'
      @report = Report.where(item_id: @order_menu_item.item.id, table_id:@order_menu_item.order.table.id).to_a.last
      @report.destroy
    end
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
