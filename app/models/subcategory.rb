class Subcategory < ActiveRecord::Base
  belongs_to :category
  has_many :items, dependent: :destroy

  validates :name, presence: true
end
