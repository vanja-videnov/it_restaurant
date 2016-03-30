class OrderMenuItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item

  def self.update_existing(order_menu_item)
    order_menu_item.quantity += 1
    order_menu_item.save
    sum = order_menu_item.order.table.sum + order_menu_item.item.price
    order_menu_item.order.table.update_attributes(sum: sum)
    Report.create(date: Date.today.to_s, table_id:order_menu_item.order.table.id, category_id:order_menu_item.item.subcategory.category.id, subcategory_id: order_menu_item.item.subcategory.id, item_id:order_menu_item.item.id)
  end

  def self.create_new(order, item)
    order_menu_item = OrderMenuItem.create(order_id: order.id, item_id: item.id, quantity: 1)
    sum = order_menu_item.order.table.sum + item.price
    order_menu_item.order.table.update_attributes(sum: sum)
    Report.create(date: Date.today.to_s, table_id: order_menu_item.order.table.id, category_id: order_menu_item.item.subcategory.category.id, subcategory_id: order_menu_item.item.subcategory.id, item_id: item.id)
  end

  def self.delete_and_update(order_menu_item)
    order_menu_item.quantity -= 1
    order_menu_item.order.table.sum -= order_menu_item.item.price
    table = order_menu_item.order.table
    table.save
    order_menu_item.save
    order_menu_item
  end
end
