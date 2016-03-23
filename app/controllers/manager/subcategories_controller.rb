class Manager::SubcategoriesController  < ManagerController
  def new
    @subcategory = Subcategory.new
    @subcategory.category_id = params[:category_id]
  end

  def create
    @subcategory = Subcategory.new(subcategory_params)
    @subcategory.category = Category.find(params[:category_id])
    if @subcategory.save
      redirect_to manager_category_path(id: @subcategory.category_id)
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
    params.require(:subcategory).permit(:name)
  end
end
