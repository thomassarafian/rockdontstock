class SneakerDbsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    @pagy, @sneaker_dbs = pagy(policy_scope(SneakerDb).order(release_date: :desc))

    if params[:query].present?
      @sneaker_dbs = @sneaker_dbs.search_by_name_category_and_price_cents(params[:query])
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'list_sneakers_db', locals: { sneaker_dbs: @sneaker_dbs } }
    end
  end

  def show
    @sneaker_db = SneakerDb.find(params[:id])
    authorize @sneaker_db
  end
end
