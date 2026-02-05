require 'rails_helper'

RSpec.describe CartsController, type: :request do
  let!(:product1) { create(:product, name: "Laptop", unit_price: 1000.0) }
  let!(:product2) { create(:product, name: "Mouse", unit_price: 50.0) }

  describe 'POST /cart' do
    it 'creates a new cart and adds a product' do
      post '/cart', params: { product_id: product1.id, quantity: 2 }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      expect(json['products'].length).to eq(1)
      expect(json['products'][0]['name']).to eq('Laptop')
      expect(json['products'][0]['quantity']).to eq(2)
      expect(json['products'][0]['total_price']).to eq(2000.0)
      expect(json['total_price']).to eq(2000.0)
    end

    it 'returns error for invalid product' do
      post '/cart', params: { product_id: 99999, quantity: 1 }

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Product not found')
    end

    it 'returns error for invalid quantity' do
      post '/cart', params: { product_id: product1.id, quantity: 0 }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Quantity must be greater than 0')
    end
  end

  describe 'GET /cart' do
    it 'returns the current cart' do
      post '/cart', params: { product_id: product1.id, quantity: 1 }
      get '/cart'

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['products'].length).to eq(1)
    end
  end

  describe 'POST /cart/add_item' do
    it 'adds quantity to existing product' do
      post '/cart', params: { product_id: product1.id, quantity: 1 }
      post '/cart/add_item', params: { product_id: product1.id, quantity: 2 }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      expect(json['products'][0]['quantity']).to eq(3)
      expect(json['products'][0]['total_price']).to eq(3000.0)
    end
  end

  describe 'DELETE /cart/:product_id' do
    it 'removes a product from cart' do
      post '/cart', params: { product_id: product1.id, quantity: 1 }
      post '/cart', params: { product_id: product2.id, quantity: 1 }
      
      delete "/cart/#{product1.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['products'].length).to eq(1)
      expect(json['products'][0]['name']).to eq('Mouse')
    end

    it 'returns error when product not in cart' do
      post '/cart', params: { product_id: product1.id, quantity: 1 }
      delete "/cart/#{product2.id}"

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Product not found in cart')
    end
  end
end
