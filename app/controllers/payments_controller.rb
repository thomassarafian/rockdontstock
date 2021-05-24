class PaymentsController < ApplicationController
  def new
    @order = current_user.orders.where(state: 'En cours').find(params[:order_id])
    authorize @order
    # SendcloudCreateLabel.new(current_user, @order).create_label
  end  
end