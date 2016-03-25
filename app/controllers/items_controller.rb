class ItemsController < ApplicationController
  before_action :is_logged_in
  def index
    @items = Item.all

  end

  def show
    @item = Item.find(params[:id])

  end

  private
  def is_logged_in
    if logged_in?
      unless current_user.manager?
        redirect_to tables_path
      end
    else
      redirect_to root_path
    end
  end
end
