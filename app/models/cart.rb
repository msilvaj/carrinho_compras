class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  enum status: { active: 0, abandoned: 1 }

  before_create :set_defaults

  # Calculate total price from all cart items
  def calculate_total_price
    cart_items.sum(&:total_price)
  end

  # Update the total_price column
  def update_total_price!
    update(total_price: calculate_total_price)
  end

  private

  def set_defaults
    self.status ||= :active
    self.total_price ||= 0.0
  end
end
