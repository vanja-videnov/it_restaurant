class Manager::SubcategoriesController < ManagerController
  def new
    if Category.count!=0
      @subcategory = Subcategory.new
      @subcategory.category_id = params[:category_id]
    else
      flash[:error] = 'Please add category first!'
      redirect_to menus_path
    end
  end

  def create
    @subcategory = Subcategory.new(subcategory_params)
    if @subcategory.save
      redirect_to menus_path
    else
      render 'new'
    end
  end

  def edit
    @subcategory = Subcategory.find(params[:id])
    render 'edit'
  end

  def update
    @subcategory = Subcategory.find(params[:id])
    if @subcategory.update(subcategory_params)
      redirect_to manager_category_path(id: @subcategory.category_id)
    else
      render 'edit'
    end
  end

  def destroy
    @subcategory = Subcategory.find(params[:id])
    category_id = @subcategory.category_id
    @subcategory.destroy
    redirect_to manager_category_path(id: category_id)
  end

  private

  def subcategory_params
    params.require(:subcategory).permit(:name, :category_id)
  end
end
