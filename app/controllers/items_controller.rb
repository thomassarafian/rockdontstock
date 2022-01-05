class ItemsController < ApplicationController
  def index
    @items = Item
  end
end
