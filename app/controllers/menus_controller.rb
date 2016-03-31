class MenusController < ApplicationController
before_action :is_logged_in
  def index
    @menus = Menu.all
    @subcategories = Subcategory.all
    @categories = Category.all
  end

  def show
    @menu = Menu.find(params[:id])
    @items = @menu.items.joins(:subcategories).joins(:categories).group(:category_id)

    @subcategories = Subcategory.includes(:items, :category).where(:items => {menu_id: @menu}).all
  end

  private
  def is_logged_in
    redirect_to root_path unless logged_in?
  end
end
