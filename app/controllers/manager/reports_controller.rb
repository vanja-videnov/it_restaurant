class Manager::ReportsController < ApplicationController
  before_action :require_manager

  def index
  end

  def show
  end

  def daily
    get_reports
    @per_items = Report.per_items('daily')
    @per_table = Report.per_table('daily')
    @item_per_table = Report.item_per_table('daily')
    @per_category = Report.per_category('daily')
    render action: :show
  end

  def items
    get_reports
    @per_items = Report.per_items('all')
    render action: :show
  end

  def tables
    get_reports
    @per_table = Report.per_table('all')
    @item_per_table = Report.item_per_table('all')
    render action: :show
  end

  def categories
    get_reports
    @per_category = Report.per_category('all')
    render action: :show
  end

  private

  def get_reports
    @reports = Report.where(date: Date.current)
    @all = Report.all
  end

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
