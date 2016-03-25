class OrdersController < ApplicationController
  def new
    @table = Table.find(params[:table_id])
    @table.update(payment: false)
    if Order.find_by(user_id: current_user, table_id: @table)
      @order = Order.find_by(user_id: current_user, table_id: @table)
    else
      @order = Order.create(user_id: current_user.id, table_id:@table.id)
    end
    @items = Item.all
  end

  def show
    @order = Order.find(params[:id])
    @items = Item.all
    @table = Table.find(params[:table_id])
    render :new
  end

  def index
    @orders = current_user.orders
  end
end
