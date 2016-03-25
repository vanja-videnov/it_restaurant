class TablesController < ApplicationController
  before_action :is_logged_in
  before_action :is_logged_manager, only: [:new, :create, :destroy]
  def index
    @tables = Table.all

  end

  def show
    @table = Table.find(params[:id])

  end

  def new

    @tables = Table.all
    @table = Table.new
  end

  def create
    @table = Table.create(number: params[:table][:number], sum: 0, payment:true)
    redirect_to tables_path
  end

  def update
    @table = Table.find(params[:id])
    @table.sum = 0
    @table.payment = true
    @table.orders.destroy_all
    @table.save
    redirect_to action: :index

  end

  def destroy
    @table = Table.find(params[:id])
    @table.destroy
    redirect_to tables_path
  end

  private
  def is_logged_in
    redirect_to root_path unless logged_in?
  end

  def is_logged_manager
    redirect_to root_path unless is_manager?
  end
end
