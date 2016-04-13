class Menu < ActiveRecord::Base
  DATE_REGEXP = /(19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])/
  has_many :items, dependent: :destroy

  validates :date, format: {with: self::DATE_REGEXP}, presence: true

end
