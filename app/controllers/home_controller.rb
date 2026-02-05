class HomeController < ApplicationController
  def index
    render json: { 
      message: "Shopping Cart API is running", 
      status: "online",
      documentation_url: "See README for usage"
    }, status: :ok
  end
end
