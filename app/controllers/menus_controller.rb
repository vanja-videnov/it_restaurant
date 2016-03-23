class MenusController < ApplicationController

  def index
    @menus = Menu.all
    @subcategories = Subcategory.all
    @categories = Category.all
  end

  def show
    @menu = Menu.find(params[:id])

  end
end
