class AddPriceToSneakers < ActiveRecord::Migration[6.1]
  def change
  	add_monetize :sneakers, :price, currency: { present: false }
  end
end
