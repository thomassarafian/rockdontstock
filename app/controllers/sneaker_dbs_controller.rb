class SneakerDbsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :create]
  def index
    if params[:query] == ""
      @sneaker_dbs = policy_scope(SneakerDb).limit(12)
    elsif params[:query].present?
      @sneaker_dbs = policy_scope(SneakerDb).limit(12)
      @sneaker_dbs = @sneaker_dbs.search_by_by_name(params[:query])
    end

    respond_to do |format|
      format.html
      format.text { render partial: 'sneaker_dbs/list_sneakers_db.html.erb', locals: { sneaker_dbs: @sneaker_dbs } }
    end
  end

  def create
    @sneaker_db = SneakerDb.create(name: params['add_sneaker_db'], img_url: "/assets/oeil-rds.png")
    authorize @sneaker_db
  end
  
end
