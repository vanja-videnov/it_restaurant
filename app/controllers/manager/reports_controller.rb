class Manager::ReportsController < ApplicationController
  def index

  end
  def show

    id = params[:id]
    case id
      when '1'
        @today = Date.current.to_s
        @reports = Report.where(date: @today)
        @all = @reports
      when '2'
        @today = Date.current.to_s
        @reports = Report.where(date: @today)
        @per_items = @reports.group(:item_id).count(:item_id, :distinct => true)
      when '3'
        @today = Date.current.to_s
        @reports = Report.where(date: @today)
        @per_table = @reports.group(:table_id, :item_id).order('table_id asc')
        @item_per_table = @reports.group(:table_id).count(:item_id, :distinct => true)
      when '4'
        @today = Date.current.to_s
        @reports = Report.where(date: @today)
        @per_category = @reports.group(:table_id, :category_id).order('table_id asc').count(:category_id, :distinct => true)
    end

  end
end
