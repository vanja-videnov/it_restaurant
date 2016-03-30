class Report < ActiveRecord::Base
  belongs_to :table
  belongs_to :category
  belongs_to :subcategory
  belongs_to :item

  def self.destroy_if_exist(item_id, table_id)
    report = Report.where(item_id: item_id, table_id: table_id).to_a.last
    report.destroy unless !report
  end

  def self.per_items(param)
    if param == 'daily'
      @today = Date.current.to_s
      @reports = Report.where(date: @today)
      @per_items = @reports.group(:item_id).count(:item_id, :distinct => true)
    else
      @reports = Report.all
      @per_items = @reports.group(:item_id).count(:item_id, :distinct => true)
    end
  end

  def self.per_table(param)
    if param == 'daily'
        @today = Date.current.to_s
        @reports = Report.where(date: @today)
        @per_table = @reports.group(:table_id, :item_id).order('table_id asc')
    else
      @reports = Report.all
      @per_table = @reports.group(:table_id, :item_id).order('table_id asc')
    end
  end

  def self.item_per_table(params)
    if params == 'daily'
      @today = Date.current.to_s
      @reports = Report.where(date: @today)
      @item_per_table = @reports.group(:table_id).count(:item_id, :distinct => true)
    else
      @reports = Report.all
      @item_per_table = @reports.group(:table_id).count(:item_id, :distinct => true)
    end
  end

  def self.per_category(params)
    if params == 'daily'
      @today = Date.current.to_s
      @reports = Report.where(date: @today)
      @per_category = @reports.group(:table_id, :category_id).order('table_id asc').count(:category_id, :distinct => true)
    else
      @reports = Report.all
      @per_category = @reports.group(:table_id, :category_id).order('table_id asc').count(:category_id, :distinct => true)
    end
  end

end
