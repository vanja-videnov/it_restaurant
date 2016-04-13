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
    @table = Table.new(number: params[:table][:number], sum: 0, payment: true)
    if @table.save
      redirect_to tables_path
    else
      render 'new'
    end
  end

  def update
    table = Table.find(params[:id])
    table.pay
    redirect_to action: :index
  end

  def destroy
    table = Table.find(params[:id])
    table.destroy
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
