class Manager::ItemsController  < ManagerController

  def new
    @item = Item.new
    @item.menu_id = params[:menu_id]

  end

  def create
    @item = Item.new(item_params)
    @item.menu_id = params[:menu_id]
    @item.subcategory = Subcategory.find(params[:item][:subcategory])
    if @item.save
      redirect_to edit_manager_menu_path(id: params[:menu_id])
    else
      render 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
    render 'edit'
  end

  def update
    @item = Item.find(params[:id])
    @item.subcategory = Subcategory.find(params[:item][:subcategory])
    if @item.update(item_params)
      redirect_to edit_manager_menu_path(id: @item.menu_id)
    else
      render 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    menu_id = @item.menu_id
    @item.destroy
    redirect_to edit_manager_menu_path(id: menu_id)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end

end
