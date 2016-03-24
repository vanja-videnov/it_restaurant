class Order < ActiveRecord::Base
  has_many :order_menu_items, dependent: :destroy
  belongs_to :table
  belongs_to :user
end
