class ItemsController < ApplicationController
  def index
    @items = policy_scope(Item)
    authorize @items
    # @order = 
  end
end