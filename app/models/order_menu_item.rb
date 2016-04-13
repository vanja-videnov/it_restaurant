class OrderMenuItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item

  def update_existing
    increment!(:quantity, 1)
    self.order.table.increment!(:sum, self.item.price)
    Report.create(date: Date.today, table_id: self.order.table_id, category_id: self.item.subcategory.category_id, subcategory_id: self.item.subcategory_id, item_id: self.item_id)
  end

  def delete_and_update(param)
    Report.destroy_if_exist(self.item_id, self.order.table_id) if param == 'true'

    decrement!(:quantity, 1)
    self.order.table.decrement!(:sum, self.item.price)

    if self.quantity == 0
      if self.order.table.sum == 0
        self.order.table.pay
        'empty'
      else
        self.destroy
        'one'
      end
    else
      'one'
    end
  end

end
