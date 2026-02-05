require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      product = build(:product)
      expect(product).to be_valid
    end

    it 'is not valid without a name' do
      product = build(:product, name: nil)
      expect(product).not_to be_valid
    end

    it 'is not valid without a unit_price' do
      product = build(:product, unit_price: nil)
      expect(product).not_to be_valid
    end

    it 'is not valid with negative unit_price' do
      product = build(:product, unit_price: -10.0)
      expect(product).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many cart_items' do
      association = described_class.reflect_on_association(:cart_items)
      expect(association.macro).to eq :has_many
    end

    it 'has many carts through cart_items' do
      association = described_class.reflect_on_association(:carts)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :cart_items
    end
  end
end
