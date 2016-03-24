class OrdersController < ApplicationController
  def new

    @table = Table.find(params[:table_id])
    @table.update(payment: false)
    @order = Order.create(user_id: current_user.id, table_id:@table.id)
    @items = Item.all
  end

  def show
    @order = Order.find(params[:id])
    @items = Item.all
    @table = Table.find(params[:table_id])
    render :new
  end
end
