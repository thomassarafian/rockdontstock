class UpdateSneakerJob < ApplicationJob
  queue_as :default

  def perform(user_id, params, sneaker_db_id)
    raise
    # @sneaker = Sneaker.new(user_id: user_id,
      # size: params['sneaker']['size'], condition: params['sneaker']['condition'], 
      # price: params['sneaker']['price'], photos: params['sneaker']['photos'],
      # box: params['sneaker']['box'], extras: params['sneaker']['extras'],
      # state: 0, sneaker_db_id: sneaker_db.id)
    puts "Calling Clearbit API for #{sneaker.size}..."
    # @sneaker.save!
    # raise
    # sneaker.update(sneaker_params)
    # TODO: perform a time consuming task like Clearbit's Enrichment API.
    # sleep 2
    puts "Done! Enriched #{user.email} with Clearbit"
  end
end
