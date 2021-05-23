class PaymentsController < ApplicationController
  def new
    @order = current_user.orders.where(state: 'En cours').find(params[:order_id])
    authorize @order
  end  
end