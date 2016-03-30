class Subcategory < ActiveRecord::Base
  belongs_to :category
  has_many :items, dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :name, presence: true
end
