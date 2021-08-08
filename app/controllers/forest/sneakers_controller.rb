class Forest::SneakersController < ForestLiana::SmartActionsController
  def validate_announcement
    sneaker_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first
    @sneaker = Sneaker.find(sneaker_id)
    @sneaker.update(state: 1)
    render json: { 
      success: "L'annonce est en ligne !"
    }
  end
end
