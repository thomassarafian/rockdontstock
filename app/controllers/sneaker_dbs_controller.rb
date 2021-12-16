class SneakerDbsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :create]

  def index
    @sneaker = Sneaker.find(params[:sneaker_id])
		results = policy_scope(SneakerDb).search_by_name(params[:search])
		@pagy, @results = pagy(results, link_extra: 'data-remote="true"', items: 18)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @sneaker_db = SneakerDb.create(name: params['add_sneaker_db'], img_url: "/assets/oeil-rds.png")
    authorize @sneaker_db
  end
  
end
