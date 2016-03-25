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

      if current_user.id == @user.id && @user.update(user_params)
        if is_manager?
          redirect_to @user
        else
          redirect_to tables_path
        end
      elsif is_manager? && @user.update(user_params_manager_updating)
          redirect_to @user
      else
        render 'edit'
      end
    else
      redirect_to root_path
    end
  end

  private

  def logged_for_edit_and_update(id)
    logged_in? && ((current_user.id.to_s == id) || is_manager?)
  end

  def user_params_manager_updating
    params.require(:user).permit(:name, :email, :telephone, :manager)
  end

  def user_params
    params.require(:user).permit(:name, :email, :telephone, :password)
  end

end
