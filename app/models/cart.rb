class Cart < ApplicationRecord
  # Relationships
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # Enums
  # Using integers for performance, mapped to readable statuses
  enum status: { active: 0, abandoned: 1 }

  # Validations
  # Fixed 'numericality' typo and 'interaction' spelling
  validates :status, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :last_interaction_at, presence: true

  # Callbacks
  # Use before_validation so default values satisfy the presence constraints
  before_validation :set_defaults, on: :create

  # Calculate total price using a SQL SUM for better performance (avoids loading all objects into memory)
  def calculate_total_price
    cart_items.sum(:total_price)
  end

  # Persist the calculated total to the database
  def update_total_price!
    update!(total_price: calculate_total_price)
  end

  private

  # Initialize default values for new records
  def set_defaults
    self.status ||= :active
    self.total_price ||= 0.0
    self.last_interaction_at ||= Time.current
  end
end
