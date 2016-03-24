class TablesController < ApplicationController
  def index
    @tables = Table.all

  end

  def show
    @table = Table.find(params[:id])

  end

  def update
    @table = Table.find(params[:id])
    @table.sum = 0
    @table.payment = true
    @table.orders.destroy_all
    @table.save
    redirect_to action: :index

  end
end
