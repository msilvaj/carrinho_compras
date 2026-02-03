class CartsController < ApplicationController
  before_action :load_or_create_cart, only: [:show, :create, :add_item]
  before_action :find_cart, only: [:destroy_item]

  # GET /cart
  def show
    render json: cart_response(@cart), status: :ok
  end

  # POST /cart
  def create
    product = Product.find_by(id: params[:product_id])
    
    unless product
      return render json: { error: "Product not found" }, status: :not_found
    end

    quantity = params[:quantity].to_i
    
    if quantity <= 0
      return render json: { error: "Quantity must be greater than 0" }, status: :unprocessable_entity
    end

    cart_item = @cart.cart_items.find_by(product_id: product.id)

    if cart_item
      cart_item.quantity += quantity
      cart_item.save!
    else
      @cart.cart_items.create!(product: product, quantity: quantity)
    end

    @cart.update!(last_interaction_at: Time.current)
    @cart.update_total_price!

    render json: cart_response(@cart), status: :ok
  end

  # POST /cart/add_item
  def add_item
    product = Product.find_by(id: params[:product_id])
    
    unless product
      return render json: { error: "Product not found" }, status: :not_found
    end

    quantity = params[:quantity].to_i
    
    if quantity <= 0
      return render json: { error: "Quantity must be greater than 0" }, status: :unprocessable_entity
    end

    cart_item = @cart.cart_items.find_by(product_id: product.id)

    if cart_item
      cart_item.quantity += quantity
      cart_item.save!
    else
      @cart.cart_items.create!(product: product, quantity: quantity)
    end

    @cart.update!(last_interaction_at: Time.current)
    @cart.update_total_price!

    render json: cart_response(@cart), status: :ok
  end

  # DELETE /cart/:product_id
  def destroy_item
    product_id = params[:product_id]
    cart_item = @cart.cart_items.find_by(product_id: product_id)

    unless cart_item
      return render json: { error: "Product not found in cart" }, status: :not_found
    end

    cart_item.destroy!
    @cart.update!(last_interaction_at: Time.current)
    @cart.update_total_price!

    render json: cart_response(@cart), status: :ok
  end

  private

  def load_or_create_cart
    cart_id = session[:cart_id]
    @cart = cart_id ? Cart.find_by(id: cart_id) : nil

    unless @cart
      @cart = Cart.create!(last_interaction_at: Time.current)
      session[:cart_id] = @cart.id
    end
  end

  def find_cart
    cart_id = session[:cart_id]
    @cart = Cart.find_by(id: cart_id)

    unless @cart
      render json: { error: "Cart not found" }, status: :not_found
    end
  end

  def cart_response(cart)
    {
      id: cart.id,
      products: cart.cart_items.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.unit_price.to_f,
          total_price: item.total_price.to_f
        }
      end,
      total_price: cart.total_price.to_f
    }
  end
end
