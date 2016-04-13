class Item < ActiveRecord::Base
  has_many :order_menu_items, dependent: :destroy
  has_many :reports, dependent: :destroy
  belongs_to :subcategory
  belongs_to :menu

  validates :price, numericality: {only_integer: true}
  validates :name, :price, :description, presence: true

  def self.create_with_params(item_params, menu_id, subcategory_id)
    @item = Item.new(item_params)
    @item.menu_id = menu_id
    @item.subcategory_id = subcategory_id
    @item.save
  end
end
