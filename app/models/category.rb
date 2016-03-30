class Category < ActiveRecord::Base
  has_many :subcategories, dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :name, presence: true
end
