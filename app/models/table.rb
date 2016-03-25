class Table < ActiveRecord::Base
  has_many :orders,dependent: :destroy
end
