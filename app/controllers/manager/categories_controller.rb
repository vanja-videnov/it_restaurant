class Manager::CategoriesController < ManagerController

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new

  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to menus_path
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
    render 'edit'
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to manager_category_path(id: params[:id])
    else
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to menus_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end


end
