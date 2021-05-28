class AddShippingDataToOrders < ActiveRecord::Migration[6.1]
  def change
  	add_monetize :orders, :shipping_cost, currency: { present: false }
  	add_monetize :orders, :insurance, currency: { present: false }
  	add_monetize :orders, :service, currency: { present: false }
  end
end
