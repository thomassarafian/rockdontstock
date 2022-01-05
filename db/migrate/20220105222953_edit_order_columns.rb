class EditOrderColumns < ActiveRecord::Migration[6.1]
  def change
    add_monetize :orders, :shipping_fee, currency: { present: false }
    add_monetize :orders, :service_fee, currency: { present: false }
    add_monetize :orders, :total_price, currency: { present: false }


    remove_monetize :orders, :shipping_cost, currency: { present: false }
    remove_monetize :orders, :service, currency: { present: false }
    remove_monetize :orders, :insurance, currency: { present: false }
    remove_monetize :orders, :price, currency: { present: false }
  end
end
