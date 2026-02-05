require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'validations and defaults' do
    it 'is valid with valid attributes' do
      cart = build(:cart)
      expect(cart).to be_valid
    end

    it 'defaults to active status' do
      cart = create(:cart)
      expect(cart.status).to eq('active')
    end

    it 'defaults total_price to 0.0' do
      cart = create(:cart)
      expect(cart.total_price).to eq(0.0)
    end
  end

  describe 'associations' do
    it 'has many cart_items' do
      association = described_class.reflect_on_association(:cart_items)
      expect(association.macro).to eq :has_many
    end

    it 'has many products through cart_items' do
      association = described_class.reflect_on_association(:products)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :cart_items
    end
  end

  describe '#calculate_total_price' do
    it 'calculates the sum of all cart items' do
      cart = create(:cart)
      product1 = create(:product, unit_price: 100.0)
      product2 = create(:product, unit_price: 50.0)
      
      create(:cart_item, cart: cart, product: product1, quantity: 2)
      create(:cart_item, cart: cart, product: product2, quantity: 1)

      expect(cart.calculate_total_price).to eq(250.0)
    end
  end

  describe '#update_total_price!' do
    it 'updates the total_price column' do
      cart = create(:cart)
      product = create(:product, unit_price: 100.0)
      create(:cart_item, cart: cart, product: product, quantity: 2)

      cart.update_total_price!
      expect(cart.reload.total_price).to eq(200.0)
    end
  end
end
