class MenusController < ApplicationController
before_action :is_logged_in
  def index
    @menus = Menu.all
    @subcategories = Subcategory.all
    @categories = Category.all
  end

  def show
    @menu = Menu.find(params[:id])

  end

  private
  def is_logged_in
    redirect_to root_path unless logged_in?
  end
end
