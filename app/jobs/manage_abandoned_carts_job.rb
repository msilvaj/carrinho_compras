class ManageAbandonedCartsJob
  include Sidekiq::Job

  # Mark carts as abandoned after 3 hours of inactivity
  # Delete carts that have been abandoned for more than 7 days
  def perform
    mark_abandoned_carts
    delete_old_abandoned_carts
  end

  private

  def mark_abandoned_carts
    # Find active carts with no interaction in the last 3 hours
    three_hours_ago = 3.hours.ago
    
    Cart.active.where("last_interaction_at < ?", three_hours_ago).find_each do |cart|
      cart.update!(status: :abandoned)
      Rails.logger.info "Cart #{cart.id} marked as abandoned"
    end
  end

  def delete_old_abandoned_carts
    # Delete carts that have been abandoned for more than 7 days
    seven_days_ago = 7.days.ago
    
    Cart.abandoned.where("updated_at < ?", seven_days_ago).find_each do |cart|
      cart.destroy!
      Rails.logger.info "Cart #{cart.id} deleted (abandoned for more than 7 days)"
    end
  end
end
