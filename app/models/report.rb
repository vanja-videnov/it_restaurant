class Report < ActiveRecord::Base
  belongs_to :table
  belongs_to :category
  belongs_to :subcategory
  belongs_to :item

  def self.destroy_if_exist(item_id, table_id)
    where(item_id: item_id, table_id: table_id).last.try(:destroy)
  end

  def self.per_items(param)
    reports = get_reports(param)
    reports.joins(:item).group('item_id').select('reports.*, count(item_id) as item_count')
  end

  def self.per_table(param)
    reports = get_reports(param)
    reports.group(:table_id, :item_id).order('table_id asc')
  end

  def self.item_per_table(param)
    reports = get_reports(param)
    reports.group(:table_id).select('reports.*, count(table_id) as table_count')
  end

  def self.per_category(param)
    reports = get_reports(param)
    reports.joins(:category).group(:table_id, :category_id).select('reports.*, count(category_id) as category_count')
  end

  def self.get_reports(param)
    if param == 'daily'
      get_today_reports
    else
      all
    end
  end

  def self.get_today_reports
    where(date: Date.current)
  end

end
