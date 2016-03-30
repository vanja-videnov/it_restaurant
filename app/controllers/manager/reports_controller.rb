class Manager::ReportsController < ApplicationController
  before_action :require_manager

  def index

  end

  def show

    @today = Date.current.to_s
    @reports = Report.where(date: @today)
    @all = Report.all

    id = params[:id]
    case id
      when '1'
        @per_items = Report.per_items('daily')
        @per_table = Report.per_table('daily')
        @item_per_table = Report.item_per_table('daily')
        @per_category = Report.per_category('daily')
      when '2'
        @per_items = Report.per_items('all')
      when '3'
        @per_table = Report.per_table('all')
        @item_per_table = Report.item_per_table('all')
      when '4'
        @per_category = Report.per_category('all')
    end
  end

  private
  def require_manager
    if logged_in?
      unless current_user.manager?
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
end
