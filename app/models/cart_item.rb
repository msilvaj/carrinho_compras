class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :product_id, uniqueness: { scope: :cart_id, message: "already exists in cart" }

  before_save :set_prices

  private

  def set_prices
    self.unit_price = product.unit_price
    self.total_price = unit_price * quantity
  end
end
