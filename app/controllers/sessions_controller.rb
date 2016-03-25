class SessionsController < ApplicationController
  def new
    if logged_in?
      if current_user.manager?
        redirect_to manager_index_path
      else
        redirect_to tables_path
      end
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      if user[:manager] == true
        redirect_to manager_index_path
      else
        redirect_to edit_user_path(id: user.id)
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
