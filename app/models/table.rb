class Table < ActiveRecord::Base
  has_many :orders,dependent: :destroy
  has_many :reports,dependent: :destroy

  validates :number, presence: true

  def self.pay(id)
    @table = Table.find(id)
    @table.update(sum: 0, payment: true)
    @table.orders.destroy_all
  end

  def empty
    self.payment = true
    self.orders.destroy_all
    self.save
  end
end
