class Manager::ItemsController < ManagerController

  def new
    menu = params[:menu_id]
    if Subcategory.exists? && Category.exists?
      @subcategories = Subcategory.all
      @item = Item.new
      @item.menu_id = menu
    elsif !Category.exists?
      flash[:error] = 'Please add category first!'
      redirect_to menus_path
    else
      flash[:error] = 'Please add subcategory first!'
      redirect_to menus_path
    end
  end

  def create
    created = Item.create_with_params(item_params, params[:menu_id], params[:item][:subcategory])
    if created
      redirect_to edit_manager_menu_path(id: params[:menu_id])
    else
      render 'new'
    end
  end

  def edit
    @subcategories = Subcategory.all
    @item = Item.find(params[:id])
    render 'edit'
  end

  def update
    @item = Item.find(params[:id])
    @item.subcategory = Subcategory.find(params[:item][:subcategory])
    if @item.update(item_params)
      redirect_to edit_manager_menu_path(id: @item.menu_id)
    else
      redirect_to action: :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])
    menu_id = @item.menu_id
    name = @item.name

    FileUtils.rm_rf('/uploads/item/#{name}') if @item.image.present?

    @item.destroy
    redirect_to menus_path
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :image)
  end

end
