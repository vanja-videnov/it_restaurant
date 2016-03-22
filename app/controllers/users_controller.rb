class UsersController < ApplicationController
  def index
    @users = User.all

  end

  def show
    @user = User.find(params[:id])

  end

  def edit
    if logged_for_edit_and_update(params[:id])
      @user = User.find(params[:id])
      render 'edit'
    else
      redirect_to root_path
    end
  end

  def update
    if logged_for_edit_and_update(params[:id])
      @user = User.find(params[:id])
      if is_manager? && current_user.id!=@user.id
        if @user.update_attributes(user_params_manager_updating)
          redirect_to @user
        else
          render 'edit'
        end
      else
        if @user.update_attributes(user_params)
          redirect_to @user
        else
          render 'edit'
        end
      end
    else
      redirect_to root_path
    end
  end

  def logged_for_edit_and_update(id)
    logged_in? && ((current_user.id.to_s == id) || is_manager?)
  end

  private
  def user_params_manager_updating
    params.require(:user).permit(:name, :email, :telephone, :manager)
  end
  def user_params
    params.require(:user).permit(:name, :email, :telephone, :password)
  end

end
