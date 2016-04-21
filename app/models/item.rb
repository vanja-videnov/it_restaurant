class Item < ActiveRecord::Base
  has_many :order_menu_items, dependent: :destroy
  has_many :reports, dependent: :destroy
  belongs_to :subcategory
  belongs_to :menu
  before_destroy :delete_image_if_present

  mount_uploader :image, ImageUploader # Tells rails to use this uploader for this model.

  validates :price, numericality: {only_integer: true}
  validates :name, :price, :description, presence: true

  def self.create_with_params(item_params, menu_id, subcategory_id)
    @item = Item.new(item_params)
    @item.menu_id = menu_id
    @item.subcategory_id = subcategory_id
    @item.save
  end

  def delete_image_if_present
    name = self.name

    FileUtils.rm_rf('/uploads/item/#{name}') if self.image.present?

  end
end
