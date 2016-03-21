class Manager::UsersController < ManagerController
  def new
    @user = User.new

  end

  def create
    @user = User.new(user_params_for_create)

    if @user.save
      redirect_to root_path
    else
      render 'new'
    end

  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  private
  def user_params_for_create
    params[:user][:manager] = false
    params.require(:user).permit(:name, :email, :manager, :telephone, :password)
  end
end