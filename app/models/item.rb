class Item < ActiveRecord::Base
  belongs_to :subcategory
  belongs_to :menu

  validates :price, numericality: { only_integer: true }
  validates :name, :price, :description, presence: true
end
