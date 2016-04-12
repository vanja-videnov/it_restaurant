class Table < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :number, presence: true

  def pay
    self.update!(sum: 0, payment: true)
    self.orders.destroy_all
  end
end
