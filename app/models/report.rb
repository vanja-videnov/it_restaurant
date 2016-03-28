class Report < ActiveRecord::Base
  belongs_to :table
  belongs_to :category
  belongs_to :subcategory
  belongs_to :item
end
