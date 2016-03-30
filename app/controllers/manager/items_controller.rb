class Manager::ItemsController  < ManagerController

  def new
    @item = Item.new
    @item.menu_id = params[:menu_id]

  end

  def create
    @created = Item.create_with_params(item_params,params[:menu_id],params[:item][:subcategory])
    if @created
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
