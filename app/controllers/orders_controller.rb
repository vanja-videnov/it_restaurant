class OrdersController < ApplicationController
  before_action :is_waiter

  def new
    @table = Table.find(params[:table_id])
    @table.update(payment: false)
    @order = Order.find_or_create_by(user_id: current_user.id, table_id: @table.id)
    @items = Item.all
    @categories = Category.all
  end

  def show
    @order = Order.find(params[:id])
    @items = Item.all
    @table = Table.find(params[:table_id])
    @categories = Category.all
    render 'new'
  end

  def index
    @orders = current_user.orders
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