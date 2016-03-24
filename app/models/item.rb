class Item < ActiveRecord::Base
  has_many :order_menu_items, dependent: :destroy
  belongs_to :subcategory
  belongs_to :menu

  validates :price, numericality: { only_integer: true }
  validates :name, :price, :description, presence: true
end
