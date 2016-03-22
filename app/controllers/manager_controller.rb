class ManagerController < ApplicationController
  before_action :require_manager

  def require_manager
    if logged_in?
      unless current_user.manager?
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
  def index

  end

end
